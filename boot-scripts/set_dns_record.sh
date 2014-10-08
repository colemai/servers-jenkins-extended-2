#!/bin/bash
set -o nounset -o xtrace

######################################################################
## variables:
##     DNS_ZONE
##     JENKINS_DNS_PREFIX
######################################################################

if [ -z "${DNS_ZONE}" ]; then
    exit 0
fi
if [ -z "${JENKINS_DNS_PREFIX}" ]; then
    exit 0
fi

# set up our route53 entries for this instance
mkdir -p /var/tmp/
cat <<EOF > /var/tmp/route53.json
{
    "Comment": "Jenkins Entry",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "{RECORD}",
                "Type": "A",
                "TTL": 60,
                "ResourceRecords": [
                    {
"Value": "{IP_ADDRESS}"
                    }
                ]
            }
        }
    ]
}
EOF

IPV4="$(curl -sL 169.254.169.254/latest/meta-data/local-ipv4)"
## if we have a public ip address, use that, if not stick with the local one
if "$(curl -sL 169.254.169.254/latest/meta-data/)" | grep -q 'public-ipv4'; then
    IPV4="$(curl -sL 169.254.169.254/latest/meta-data/public-ipv4)"
fi
    
tmp_file="$(mktemp -t dns-XXXX)"
dns="$(echo "$DNS_ZONE" | perl -pe 's{\.$}{}g')"
zone=$(cat <<EOF > "$tmp_file"
aws route53 list-hosted-zones --query 'HostedZones[?Name==\`${dns}.\`].Id'
EOF
sh -x "$tmp_file" | grep hostedzone | perl -pe 's{\s*\"(.*)\"}{\1}g'
)
rm -f "$tmp_file"
aws route53 change-resource-record-sets --hosted-zone-id $zone --change-batch "$(cat /var/tmp/route53.json | perl -pe "s#{RECORD}#${JENKINS_DNS_PREFIX}.${dns}#g; s#{IP_ADDRESS}#${IPV4}#g")"

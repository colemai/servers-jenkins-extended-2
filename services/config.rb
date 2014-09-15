## This file was automatically generated using the CloudCoreo CLI
##
## This config.rb file exists to create and maintain services not related to compute.
## for example, a VPC might be maintained using:
##
## coreo_aws_vpc_vpc "my-vpc" do
##   action :sustain
##   cidr "12.0.0.0/16"
##   internet_gateway true
## end
##

coreo_aws_ec2_securityGroups "${JENKINS_NAME}" do
  action :sustain
  description "Jenkins security group"
  vpc "${VPC_NAME}"
  allows [ 
          { 
            :direction => :ingress,
            :protocol => :tcp,
            :ports => ${JENKINS_INGRESS_PORTS},
            :cidrs => ${JENKINS_INGRESS_CIDRS}
          },{ 
            :direction => :egress,
            :protocol => :tcp,
            :ports => ["0..65535"],
            :cidrs => ["0.0.0.0/0"]
          }
    ]
end

coreo_aws_iam_policy "${JENKINS_NAME}" do
  action :sustain
  policy_name "AllowS3Backup"
  policy_document <<-EOH
{
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
          "arn:aws:s3:::${BACKUP_BUCKET}/${REGION}/jenkins/${ENV}/${JENKINS_NAME}",
          "arn:aws:s3:::${BACKUP_BUCKET}/${REGION}/jenkins/${ENV}/${JENKINS_NAME}/*"
      ],
      "Action": [ 
          "s3:*"
      ]
    }
  ]
}
EOH
end

coreo_aws_iam_instance_profile "${JENKINS_NAME}" do
  action :sustain
  policies ["${JENKINS_NAME}"]
end

coreo_aws_ec2_instance "${JENKINS_NAME}" do
  action :define
  image_id "${JENKINS_AMI}"
  size "${JENKINS_SIZE}"
  security_groups ["${JENKINS_NAME}"]
  role "${JENKINS_NAME}"
  ssh_key "${JENKINS_KEYPAIR}"
end

coreo_aws_ec2_autoscaling "${JENKINS_NAME}" do
  action :sustain 
  minimum 1
  maximum 1
  server_definition "${JENKINS_NAME}"
  subnet "${PRIVATE_SUBNET_NAME}"
end

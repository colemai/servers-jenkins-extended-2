#!/bin/bash

if ! rpm -qa | grep -q cloudcoreo-directory-backup; then
    yum install -y cloudcoreo-directory-backup
fi

MY_AZ="$(curl -sL 169.254.169.254/latest/meta-data/placement/availability-zone)"
MY_REGION="$(echo ${MY_AZ%?})"

echo "${JENKINS_BACKUP_CRON} ps -fwwC python | grep -q cloudcoreo-directory-backup || { cd /opt/; nohup python cloudcoreo-directory-backup.py --s3-backup-region ${BACKUP_BUCKET_REGION} --s3-backup-bucket ${BACKUP_BUCKET} --s3-prefix ${MY_REGION}/jenkins/${ENV}/${JENKINS_NAME} --directory /var/lib/jenkins --dump-dir /tmp & }" | crontab

#!/bin/bash

if ! rpm -qa | grep -q apache-maven; then
    (
        cd /tmp/
	wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
	sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
	yum install -y apache-maven
    )
fi

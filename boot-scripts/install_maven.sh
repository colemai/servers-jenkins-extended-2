#!/bin/bash

if [ ! -d "/usr/local/apache-maven-3.2.3" ]; then
    (
        cd /tmp/
        wget http://apache.mirrors.hoobly.com/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz
        tar -zxf apache-maven-3.2.3-bin.tar.gz
        rm -f apache-maven-3.2.3-bin.tar.gz
        mv apache-maven-3.2.3 /usr/local/
    )
fi

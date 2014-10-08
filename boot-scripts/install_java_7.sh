#!/bin/bash

(
    cd /tmp
    pkg="jdk-7u67-linux-i586.rpm"
    rm -f "/tmp/$pkg"
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u67-b01/$pkg"
    rpm -ivh "/tmp/$pkg"
)

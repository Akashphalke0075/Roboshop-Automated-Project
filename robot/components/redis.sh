#!/bin/bash

set -e
COMPONENT=redis

source components/common.sh

echo -n "downloading the component: "
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo &>> $LOGFILE
stat $?

echo -n "installing $COMPONENT: "
yum install $COMPONENT-6.2.11 -y &>> $LOGFILE
stat $?

echo -n "listening the port: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT/$COMPONENT.conf
stat $?


echo -n "starting $COMPONENT : "
systemctl enable $COMPONENT &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
stat $?
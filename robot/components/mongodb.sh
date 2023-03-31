#!/bin/bash

set -e
COMPONENT=mongodb

source components/common.sh

echo -n "downloading components: "
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo  &>> $LOGFILE
stat $?

echo -n "installing $COMPONENT: "
yum install -y $COMPONENT-org   &>> $LOGFILE
stat $?

echo -n "listening the port: "
sed -e -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  
stat $?

echo -n "downloading the component: "
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "downloading the component: "
cd /tmp
unzip $COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "ijnecting schema: "
cd $COMPONENT-main
mongo < catalogue.js  &>> $LOGFILE
mongo < users.js   &>> $LOGFILE
stat $?


echo -n "starting $COMPONENT : "
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?





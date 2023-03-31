#!/bin/bash

set -e
COMPONENT=redis

source components/common.sh

echo -n "downloading the component: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $?

echo -n "installing redis: "
yum install redis-6.2.11 -y &>> $LOGFILE
stat $?

echo -n "listening the port: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?


echo -n "starting redis : "
systemctl enable redis &>> $LOGFILE
systemctl start redis &>> $LOGFILE
stat $?
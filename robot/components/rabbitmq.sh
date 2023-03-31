#!/bin/bash


COMPONENT=rabbitmq
APPUSER=roboshop
source components/common.sh

echo -n "downloading components: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash   &>> $LOGFILE
stat $?

echo -n "downloading components two: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash  &>> $LOGFILE
stat $?

echo -n "installing rabbitmq: "
yum install rabbitmq-server -y &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT : "
systemctl enable rabbitmq-server  &>> $LOGFILE
systemctl start rabbitmq-server  &>> $LOGFILE
stat $?

echo -n "adding user : "
rabbitmqctl list_users | grep roboshop &>> $LOGFILE
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop roboshop123
stat $?
fi

echo -n "adding permission tag : "
rabbitmqctl set_user_tags roboshop administrator  &>> $LOGFILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOGFILE
stat $?




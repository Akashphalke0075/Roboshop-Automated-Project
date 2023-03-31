#!/bin/bash

set -e
COMPONENT=catalogue

source components/common.sh

echo -n "downloading components: "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "installing $COMPONENT: "
yum install nodejs -y  &>> $LOGFILE  &>> $LOGFILE
stat $?

echo -n "creating user: "
useradd roboshop
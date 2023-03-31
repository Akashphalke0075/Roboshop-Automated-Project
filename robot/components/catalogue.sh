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
stat $?

echo -n "downloafing $COMPONENT: "
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"  &>> $LOGFILE

echo -n "unzipping the component adn moving: "
cd /home/roboshop
unzip -o /tmp/catalogue.zip  &>> $LOGFILE
mv catalogue-main catalogue
stat $?

cd /home/roboshop/catalogue
npm install &>> $LOGFILE
stat $?

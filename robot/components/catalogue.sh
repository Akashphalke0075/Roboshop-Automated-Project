#!/bin/bash

set -e
COMPONENT=catalogue
APPUSER=roboshop
source components/common.sh

echo -n "downloading components: "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "installing nodejs: "
yum install nodejs -y  &>> $LOGFILE 
stat $?


echo -n "creating user: "
id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
useradd $APPUSER &>> $LOGFILE
fi
stat $?

echo -n "downloafing $COMPONENT: "
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "unzipping the component adn moving: "
cd /home/$APPUSER
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE

rm -rf $COMPONENT
mv $COMPONENT-main $COMPONENT
stat $?

cd /home/$APPUSER/$COMPONENT
npm install &>> $LOGFILE
stat $?

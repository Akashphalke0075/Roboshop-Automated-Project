#!/bin/bash

set -e
COMPONENT=frontend

source components/common.sh

echo -n "installing nginx: "
yum install nginx -y  &>> $LOGFILE
stat $?


echo -n "downloading the component: "
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "cleaning up the component: "
rm -rf /usr/share/nginx/html/*  &>> $LOGFILE
stat $?

cd /usr/share/nginx/html
echo -n "unzipping the component adn moving: "
unzip /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "moving and removing file: "
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
stat $?

echo -n "unzipping the component adn moving : "
mv localhost.conf /etc/nginx/default.d/roboshop.conf  
stat $?

for component in catalogue cart user shipping payment; do
    echo -n "Configuring Reverse Proxy : "
    sed -i -e "/$component/s/localhost/$component.robot.internal/"  /etc/nginx/default.d/roboshop.conf 
    stat $?
done


echo -n "starting nginx : "
systemctl enable nginx  &>> $LOGFILE
systemctl start nginx   &>> $LOGFILE
stat $?




















# systemctl enable nginx
# systemctl start nginx
#!/bin/bash

set -e 

COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log
USERID=$(id -u) 

if [ $USERID -ne 0 ]; then
echo -e "\e[31m please run as sudo user or root \e[0m"
exit 1
fi

stat () {
if [ $1 -eq  0 ]; then
echo -e "\e[32msuccess \e[0m"
else
echo -e "\e[31mfailure \e[0m"
fi
}

echo -n "installing nginx: "
yum install nginx -y   &>> $LOGFILE
stat $?


echo -n "downloading component: "
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "cleaunup performing: "
rm -rf /usr/share/nginx/html/* &>> $LOGFILE
stat $?

cd /usr/share/nginx/html
echo -n "unzipping components: "
unzip /tmp/$COMPONENT.zip  &>> $LOGFILE
echo -n "moving components: "
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
stat $?

echo -n "configuring reverse proxy: "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "installing nginx: "
systemctl enable nginx  &>> $LOGFILE
systemctl start nginx   &>> $LOGFILE
stat $?


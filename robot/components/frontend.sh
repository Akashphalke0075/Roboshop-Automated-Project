#!/bin/bash

set -e
COMPONENT=frontend
LOGFILE=/tmp/frontend.log
USERID=$(id -u) 

if [ $USERID -ne 0 ]; then
echo -e "\e[31mplease login as sudo \e[0m"
exit 1
fi

stat() {
if [ $? -eq 0 ]; then
echo -e "\e[32mSuccess \e[0m"
else
echo -e "\e[31mFailure \e[0m"
fi
}

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
echo -n "unzipping the component adn moving : "
unzip /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
stat $?

echo -n "unzipping the component adn moving : "
mv localhost.conf /etc/nginx/default.d/roboshop.conf  
stat $?


echo -n "starting nginx : "
systemctl enable nginx  &>> $LOGFILE
systemctl start nginx   &>> $LOGFILE
stat $?




















# systemctl enable nginx
# systemctl start nginx
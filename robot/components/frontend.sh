#!/bin/bash

echo -e "\e[32m installing nginx \e[0m"
yum install nginx -y  

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html

unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf



systemctl enable nginx
systemctl start nginx


















# systemctl enable nginx
# systemctl start nginx



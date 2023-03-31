#!/bin/bash


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
stat $?

echo -n "performing cleaup: "
rm -rf $COMPONENT
mv $COMPONENT-main $COMPONENT
stat $?

echo -n "installing npm: "
cd /home/$APPUSER/$COMPONENT
npm install &>> $LOGFILE
stat $?

echo -n "Changing permissions: "
chown -R $APPUSER:$APPUSER  /home/$APPUSER/$COMPONENT
stat $

echo -n "Configuring dns name: "
sed -i -e 's/MONGO_DNSNAME/mongodb.robot.internal/'  /home/$APPUSER/$COMPONENT/systemd.service 
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "starting nginx : "
systemctl daemon-reload &>> $LOGFILE
systemctl start catalogue &>> $LOGFILE
systemctl enable catalogue &>> $LOGFILE
stat $?
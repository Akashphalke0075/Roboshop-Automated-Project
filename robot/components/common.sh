
LOGFILE=/tmp/$COMPONENT.log

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

NODEJS() {
    echo -n "downloading components: "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "installing nodejs: "
yum install nodejs -y  &>> $LOGFILE 
stat $?
#CALLING CREATE USER
CREATE_USER
#CALLING DOWNLOADINGING AND EXTRACT
DOWNLOAD_EXTRACT
#CALLING NPM DEPENDENCIES
NPM_INSTALL
#CALLING CONFIGURE SERVICE
CONFIGURE_SERVICE
}

CREATE_USER() {
    echo -n "creating user: "
id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
useradd $APPUSER &>> $LOGFILE
fi
stat $?
}

DOWNLOAD_EXTRACT() {
    echo -n "Downloading the $COMPONENT:"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $? 

    echo -n "Performing Cleanup:"
    rm -rf /home/$APPUSER/$COMPONENT
    cd /home/$APPUSER/ 
    unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE && mv $COMPONENT-main $COMPONENT  &>> $LOGFILE 
    stat $? 

    echo -n "Changing permissions to $APPUSER"
    chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT &&  chmod -R 775 /home/roboshop/$COMPONENT 
    stat $?
}

NPM_INSTALL() {
    echo -n "installing npm: "
cd /home/$APPUSER/$COMPONENT
npm install &>> $LOGFILE
stat $?
}

CONFIGURE_SERVICE() {
echo -n "Configuring dns name: "
sed -i -e 's/MONGO_DNSNAME/mongodb.robot.internal/' -e 's/CARTENDPOINT/cart.robot.internal/' -e 's/DBHOST/mysql.robot.internal/'   -e 's/MONGO_ENDPOINT/mongodb.robot.internal/' -e 's/REDIS_ENDPOINT/redis.robot.internal/'  -e 's/REDIS_ENDPOINT/redis.robot.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.robot.internal/'   /home/$APPUSER/$COMPONENT/systemd.service 
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?
echo -n "starting nginx : "
systemctl daemon-reload &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
stat $?
}


MAVEN() {
echo -n "installing maven: "    
yum install maven -y  &>> $LOGFILE

CREATE_USER

DOWNLOAD_EXTRACT

MVN_INSTALL
 
CONFIGURE_SERVICE

}


MVN_INSTALL() {
    echo -n "Installing $COMPONENT Dependencies: "
    cd $COMPONENT 
    mvn clean package &>> $LOGFILE
     mv target/$COMPONENT-1.0.jar $COMPONENT.jar
    stat $?
}


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

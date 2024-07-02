script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[31m<<<<<<<<<Install NodeJS>>>>>>>>>\e[0m"
dnf install nodejs -y

echo -e "\e[31m<<<<<<<<<Add application User>>>>>>>>>\e[0m"
useradd ${app_user}


echo -e "\e[31m<<<<<<<<<Setup an app directory>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m<<<<<<<<<Download the application code>>>>>>>>>\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

echo -e "\e[31m<<<<<<<<<Download the dependencies>>>>>>>>>\e[0m"
npm install

echo -e "\e[31m<<<<<<<<<Setup SystemD User Service>>>>>>>>>\e[0m"
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[31m<<<<<<<<<Load and Start the service>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[31m<<<<<<<<<setup MongoDB repo>>>>>>>>>\e[0m"
cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m<<<<<<<<<Install mongodb-client>>>>>>>>>\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[31m<<<<<<<<<load the schema>>>>>>>>>\e[0m"
mongo --host mongod-dev.gdevops89.online </app/schema/user.js

echo -e "\e[31m<<<<<<<<<Restart Service>>>>>>>>>\e[0m"
systemctl restart user
script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh


echo -e "\e[31m<<<<<<<<<List the modules and enable 18 version>>>>>>>>>\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[31m<<<<<<<<<IInstall NodeJS>>>>>>>>>\e[0m"
dnf install nodejs -y

echo -e "\e[31m<<<<<<<<<Add application User to configure application>>>>>>>>\e[0m"
useradd ${app_user}

echo -e "\e[31m<<<<<<<<<Setup an app directory>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m<<<<<<<<<Download the application code to created app directory>>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[31m<<<<<<<<<Download the dependencies>>>>>>>>>\e[0m"
npm install

echo -e "\e[31m<<<<<<<<<Setup SystemD Catalogue Service>>>>>>>>>\e[0m"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m<<<<<<<<<Load and Start the service>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[31m<<<<<<<<<setup MongoDB repo>>>>>>>>>\e[0m"
cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m<<<<<<<<<Install mongodb-client>>>>>>>>>\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[31m<<<<<<<<<load the schema>>>>>>>>>\e[0m"
mongo --host mongod-dev.gdevops89.online </app/schema/catalogue.js

echo -e "\e[31m<<<<<<<<<Restart Service>>>>>>>>>\e[0m"
systemctl restart catalogue
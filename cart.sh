script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[31m<<<<<<<<<List the modules and enable nodejs 18 version>>>>>>>>>\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
#curl -sl https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m<<<<<<<<<Install NodeJS>>>>>>>>>\e[0m"
dnf install nodejs -y

echo -e "\e[31m<<<<<<<<<Add application User>>>>>>>>>\e[0m"
useradd ${app_user}

echo -e "\e[31m<<<<<<<<<Setup an app directory>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m<<<<<<<<<Download the application code>>>>>>>>>\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

echo -e "\e[31m<<<<<<<<<Download the dependencies>>>>>>>>>\e[0m"
npm install

echo -e "\e[31m<<<<<<<<<Setup SystemD Cart Service>>>>>>>>>\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service

echo -e "\e[31m<<<<<<<<<Load and Start the service>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart
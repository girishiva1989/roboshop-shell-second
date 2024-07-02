script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
#RoboShop@1
mysql_user_password=$*

echo -e "\e[31m<<<<<<<<<Install Maven>>>>>>>>>\e[0m"
dnf install maven -y

echo -e "\e[31m<<<<<<<<<Add application User>>>>>>>>>\e[0m"
useradd ${app_user}

echo -e "\e[31m<<<<<<<<<Setup app directory>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m<<<<<<<<<Download the application code>>>>>>>>>\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

echo -e "\e[31m<<<<<<<<<Download the dependencies>>>>>>>>>\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m<<<<<<<<<Setup SystemD Shipping Service>>>>>>>>>\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m<<<<<<<<<Load and Start the service>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

echo -e "\e[31m<<<<<<<<<Install mysql client>>>>>>>>>\e[0m"
dnf install mysql -y

echo -e "\e[31m<<<<<<<<<Load schema>>>>>>>>>\e[0m"
mysql -h mysql-dev.gdevops89.online -uroot -p${mysql_user_password}< /app/schema/shipping.sql

echo -e "\e[31m<<<<<<<<<Restart Service>>>>>>>>>\e[0m"
systemctl restart shipping

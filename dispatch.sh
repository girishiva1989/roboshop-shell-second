script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[31m<<<<<<<<<Install GoLang>>>>>>>>>\e[0m"
dnf install golang -y

echo -e "\e[31m<<<<<<<<<Add application User>>>>>>>>>\e[0m"
useradd ${add_user}

echo -e "\e[31m<<<<<<<<<Setup app directory>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m<<<<<<<<<Download the application code>>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[31m<<<<<<<<<Download the dependencies>>>>>>>>>\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[31m<<<<<<<<<Setup SystemD Dispatch Service>>>>>>>>>\e[0m"
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[31m<<<<<<<<<Load and Start the service>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch
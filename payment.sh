script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_user_password=$*

if  [ -z "${rabbitmq_user_password}" ]
then
  echo input not provided
  exit
fi

echo -e "\e[31m<<<<<<<<<Install Python 3.6>>>>>>>>>\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[31m<<<<<<<<<Add application User>>>>>>>>>\e[0m"
useradd ${app_user}

echo -e "\e[31m<<<<<<<<<Setup app directory>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m<<<<<<<<<Download the application code>>>>>>>>>\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

echo -e "\e[31m<<<<<<<<<Download the dependencies>>>>>>>>>\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[31m<<<<<<<<<Setup SystemD Payment Service>>>>>>>>>\e[0m"
sed -i -e "s|rabbitmq_user_password|${rabbitmq_user_password}|g" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[31m<<<<<<<<<Load and Start the service>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment
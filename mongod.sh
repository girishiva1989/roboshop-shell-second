script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[31m<<<<<<<<<Setup the MongoDB repo file>>>>>>>>>\e[0m"
cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m<<<<<<<<<Install MongoDB>>>>>>>>>\e[0m"
dnf install mongodb-org -y

echo -e "\e[31m<<<<<<<<<Start & Enable MongoDB Service>>>>>>>>>\e[0m"
systemctl enable mongod
systemctl start mongod

echo -e "\e[31m<<<<<<<<<IUpdate listen address from 127.0.0.1 to 0.0.0.0>>>>>>>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/mongod.conf
# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

echo -e "\e[31m<<<<<<<<<Restart MongoDB service>>>>>>>>>\e[0m"
systemctl restart mongod
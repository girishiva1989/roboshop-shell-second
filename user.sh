script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

component=user
fun_nodejs

echo -e "\e[31m<<<<<<<<<setup MongoDB repo>>>>>>>>>\e[0m"
cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m<<<<<<<<<Install mongodb-client>>>>>>>>>\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[31m<<<<<<<<<load the schema>>>>>>>>>\e[0m"
mongo --host mongod-dev.gdevops89.online </app/schema/user.js

echo -e "\e[31m<<<<<<<<<Restart Service>>>>>>>>>\e[0m"
systemctl restart user
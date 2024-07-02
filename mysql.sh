script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
#RoboShop@1
mysql_user_password=$*

dnf module disable mysql -y

echo -e "\e[31m<<<<<<<<<Setup MySQL5.7 repo file>>>>>>>>>\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m<<<<<<<<<Install MySQL Server>>>>>>>>>\e[0m"
dnf install mysql-community-server -y

echo -e "\e[31m<<<<<<<<<Start Service>>>>>>>>>\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[31m<<<<<<<<<Change the default root password>>>>>>>>>\e[0m"
mysql_secure_installation --set-root-pass ${mysql_user_password}

echo -e "\e[31m<<<<<<<<<Check the new password is working>>>>>>>>>\e[0m"
mysql -uroot -p${mysql_user_password}
quit
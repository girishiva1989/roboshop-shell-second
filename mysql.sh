script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
#RoboShop@1
mysql_user_password=$*

if  [ -z "${mysql_user_password}" ]
then
  echo input not provided
  exit 1
fi

fun_print_head "Disable Module 8 Version"
dnf module disable mysql -y &>>${log_file}
fun_status_check $?

fun_print_head "Setup MySQL5.7 repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
fun_status_check $?

fun_print_head "Install MySQL Server"
dnf install mysql-community-server -y &>>${log_file}
fun_status_check $?

fun_print_head "Start Service"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
fun_status_check $?

fun_print_head "Change the default root password"
mysql_secure_installation --set-root-pass ${mysql_user_password} &>>${log_file}
fun_status_check $?

#fun_print_head "Check the new password is working"
#mysql -uroot -p${mysql_user_password} &>>${log_file}
#fun_status_check $?
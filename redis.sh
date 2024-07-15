script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

fun_print_head "Install Redis Repo file"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
fun_status_check $?

fun_print_head "Enable Redis 6.2"
dnf module enable redis:remi-6.2 -y &>>${log_file}
fun_status_check $?

fun_print_head "Install Redis"
dnf install redis -y &>>${log_file}
fun_status_check $?

fun_print_head "Update listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
fun_status_check $?
# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf

fun_print_head "Install NodeJS"
systemctl enable redis &>>${log_file}
systemctl start redis &>>${log_file}
fun_status_check $?
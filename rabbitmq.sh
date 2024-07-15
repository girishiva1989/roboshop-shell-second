script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

#roboshop123
rabbitmq_user_password=$*

if  [ -z "${rabbitmq_user_password}" ]
then
  echo input not provided
  exit
fi

fun_print_head "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
fun_status_check $?

fun_print_head "Configure YUM Repos for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
fun_status_check $?

fun_print_head "Install RabbitMQ"
dnf install rabbitmq-server -y &>>${log_file}
fun_status_check $?

fun_print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>${log_file}
systemctl start rabbitmq-server &>>${log_file}
fun_status_check $?

fun_print_head "Create one user for the application"
rabbitmqctl add_user roboshop ${rabbitmq_user_password} &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
fun_status_check $?


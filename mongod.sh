script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

fun_print_head "Setup the MongoDB repo file"
cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
fun_status_check $?

fun_print_head "Install MongoDB"
dnf install mongodb-org -y &>>${log_file}
fun_status_check $?

fun_print_head "Start & Enable MongoDB Service"
systemctl enable mongod &>>${log_file}
systemctl start mongod &>>${log_file}
fun_status_check $?

fun_print_head "IUpdate listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/mongod.conf &>>${log_file}
fun_status_check $?
# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

fun_print_head "Restart MongoDB service"
systemctl restart mongod &>>${log_file}
fun_status_check $?
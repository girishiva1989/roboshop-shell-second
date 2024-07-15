script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh


fun_print_head "Install nginx"
dnf install nginx -y &>>${log_file}
fun_status_check $?

fun_print_head "Start & Enable Nginx service"
systemctl enable nginx &>>${log_file}
systemctl start nginx &>>${log_file}
fun_status_check $?

fun_print_head "Remove the default content that web server is serving"
rm -rf /usr/share/nginx/html/* &>>${log_file}
fun_status_check $?

fun_print_head "Download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
fun_status_check $?

fun_print_head "Extract the frontend content"
cd /usr/share/nginx/html &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
fun_status_check $?

fun_print_head "Create Nginx Reverse Proxy Configuration"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
fun_status_check $?

fun_print_head "Restart Nginx Service"
systemctl restart nginx &>>${log_file}
fun_status_check $?
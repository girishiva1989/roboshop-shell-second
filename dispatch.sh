script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

component=dispatch


fun_print_head "Install GoLang"
dnf install golang -y &>>${log_file}
fun_status_check $?

fun_app_prereq

fun_print_head "Download the dependencies"
go mod init dispatch &>>${log_file}
go get &>>${log_file}
go build &>>${log_file}
fun_status_check $?

fun_systemd_setup
app_user=roboshop
log_file=/tmp/roboshop.log

fun_print_head() {
  echo -e "\e[31m<<<<<<<<<$*>>>>>>>>>\e[0m"
  echo -e "\e[31m<<<<<<<<<$*>>>>>>>>>\e[0m" &>>${log_file}
}


fun_schema_setup()
{
  if [ "$schema_setup" == "mongod" ]; then
    fun_print_head "setup MongoDB repo"
    cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    fun_status_check $?

    fun_print_head "Install mongodb-client"
    dnf install mongodb-org-shell -y &>>${log_file}
    fun_status_check $?

    fun_print_head "load the schema"
    mongo --host mongod-dev.gdevops89.online </app/schema/${component}.js &>>${log_file}
    fun_status_check $?

    fun_print_head "Restart Service"
    systemctl restart ${component} &>>${log_file}
    fun_status_check $?
  fi
  if [ "$schema_setup" == "mysql" ]; then
    fun_print_head "Install mysql client"
    dnf install mysql -y &>>${log_file}
    fun_status_check $?

    fun_print_head "Load schema"
    mysql -h mysql-dev.gdevops89.online -uroot -p${mysql_user_password}< /app/schema/${component}.sql &>>${log_file}
    fun_status_check $?
  fi
}

fun_status_check()
{
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[32mError\e[0m"
    echo -e "\e[32mError message redirected to ${log_file}"
    exit 1
  fi
}

fun_app_prereq()
{
    fun_print_head "Add application User"
    id ${app_user} &>>${log_file}
    if [ $? -ne 0 ]; then
      useradd ${app_user} &>>${log_file}
    fi

    fun_status_check $?

    fun_print_head "Setup an app directory"
    rm -rf /app &>>${log_file}
    mkdir /app &>>${log_file}
    fun_status_check $?

    fun_print_head "Download the application"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    cd /app
    unzip /tmp/${component}.zip &>>${log_file}
    fun_status_check $?

}

fun_systemd_setup()
{

  fun_print_head "Setup SystemD ${component} Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  fun_status_check $?

  fun_print_head "Load and Start the service"
  systemctl daemon-reload &>>${log_file}
  systemctl enable ${component} &>>${log_file}
  systemctl start ${component} &>>${log_file}
  fun_status_check $?

}

fun_nodejs()
{
  fun_print_head "List the modules and enable 18 version"
  dnf module disable nodejs -y &>>${log_file}
  dnf module enable nodejs:18 -y &>>${log_file}
  fun_status_check $?

  fun_print_head "Install NodeJS"
  dnf install nodejs -y &>>${log_file}
  fun_status_check $?

  fun_app_prereq

  fun_print_head "Download the dependencies"
  npm install &>>${log_file}
  fun_status_check $?

  fun_systemd_setup

  fun_schema_setup


}

fun_java() {
  fun_print_head "Install Maven"
  dnf install maven -y &>>${log_file}
  fun_status_check $?

  fun_app_prereq

  fun_print_head "Download the dependencies"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  fun_status_check $?

  fun_systemd_setup

  fun_schema_setup


}

fun_python()
{
  fun_print_head "Install Python 3.6"
  dnf install python36 gcc python3-devel -y &>>${log_file}
  fun_status_check $?

  fun_app_prereq

  fun_print_head "Download the dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  fun_status_check $?

  fun_print_head "Update Password in System Service file"
  sed -i -e "s|rabbitmq_user_password|${rabbitmq_user_password}|" ${script_path}/payment.service &>>${log_file}
  fun_status_check $?

  fun_systemd_setup
}

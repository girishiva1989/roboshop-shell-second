app_user=roboshop

fun_print_head()
{
  echo -e "\e[31m<<<<<<<<<$*>>>>>>>>>\e[0m"
}


fun_schema_setup()
{
  if ["$schema_setup" == "mongod"]
  then
  fun_print_head "setup MongoDB repo"
  cp ${script_path}/mongod.repo /etc/yum.repos.d/mongo.repo

  fun_print_head "Install mongodb-client"
  dnf install mongodb-org-shell -y

  fun_print_head "load the schema"
  mongo --host mongod-dev.gdevops89.online </app/schema/${component}.js

  fun_print_head "Restart Service"
  systemctl restart ${component}
  fi
}
fun_nodejs()
{
  fun_print_head "List the modules and enable 18 version"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  fun_print_head "Install NodeJS"
  dnf install nodejs -y

  fun_print_head "Add application User"
  useradd ${app_user}

  fun_print_head "Setup an app directory"
  rm -rf /app
  mkdir /app

  fun_print_head "Download the application"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  fun_print_head "Download the dependencies"
  npm install

  fun_print_head "Setup SystemD ${component} Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  fun_print_head "Load and Start the service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

  fun_schema_setup

}
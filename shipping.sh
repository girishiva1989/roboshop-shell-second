script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
#RoboShop@1
component=shipping
schema_setup=mysql
mysql_user_password=$*

if  [ -z "${mysql_user_password}" ]
then
  echo input not provided
  exit
fi

fun_java


script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_user_password=$*

if  [ -z "${rabbitmq_user_password}" ]
then
  echo input not provided
  exit
fi

component=payment
fun_python
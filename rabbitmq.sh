#roboshop123
rabbitmq_user_password=$*

echo -e "\e[31m<<<<<<<<<Configure YUM Repos>>>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[31m<<<<<<<<<Configure YUM Repos for RabbitMQ>>>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[31m<<<<<<<<<Install RabbitMQ>>>>>>>>>\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[31m<<<<<<<<<EStart RabbitMQ Service>>>>>>>>>\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[31m<<<<<<<<<Create one user for the application>>>>>>>>>\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_user_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


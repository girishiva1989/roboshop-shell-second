echo -e "\e[31m<<<<<<<<<IInstall Redis Repo file>>>>>>>>>\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[31m<<<<<<<<<Enable Redis 6.2>>>>>>>>>\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[31m<<<<<<<<<Install Redis>>>>>>>>>\e[0m"
dnf install redis -y

echo -e "\e[31m<<<<<<<<<Update listen address from 127.0.0.1 to 0.0.0.0>>>>>>>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/redis.conf /etc/redis/redis.conf
# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf

echo -e "\e[31m<<<<<<<<<IInstall NodeJS>>>>>>>>>\e[0m"
systemctl enable redis
systemctl start redis
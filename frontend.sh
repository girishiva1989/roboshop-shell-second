script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[31m<<<<<<<<<Install nginx>>>>>>>>>\e[0m"
dnf install nginx -y

echo -e "\e[31m<<<<<<<<<Start & Enable Nginx service>>>>>>>>>\e[0m"
systemctl enable nginx
systemctl start nginx

echo -e "\e[31m<<<<<<<<<Remove the default content that web server is serving>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[31m<<<<<<<<<Download the frontend content>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[31m<<<<<<<<<Extract the frontend content>>>>>>>>>\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[31m<<<<<<<<<Create Nginx Reverse Proxy Configuration>>>>>>>>\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31m<<<<<<<<<Restart Nginx Service>>>>>>>>>\e[0m"
systemctl restart nginx
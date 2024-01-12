#!/bin/bash

# 替换 H5 端配置文件中的数据库连接信息
sed -i "s/APP_URL=http:\/\/localhost/APP_URL=${H5_APP_URL}/" /var/www/html/.env
sed -i "s/DB_DATABASE=mydatabase/DB_DATABASE=${H5_DB_DATABASE}/" /var/www/html/.env
sed -i "s/DB_USERNAME=myuser/DB_USERNAME=${H5_DB_USERNAME}/" /var/www/html/.env
sed -i "s/DB_PASSWORD=mypassword/DB_PASSWORD=${H5_DB_PASSWORD}/" /var/www/html/.env

# 启动 Apache
apache2-foreground
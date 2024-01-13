#!/bin/bash

# 替换 H5 端配置文件中的数据库连接信息
perl -pi -e 's/APP_URL=http:\/\/localhost/APP_URL=$ENV{"H5_APP_URL"}/' /var/www/html/.env
perl -pi -e 's/DB_DATABASE=mydatabase/DB_DATABASE=$ENV{"H5_DB_DATABASE"}/' /var/www/html/.env
perl -pi -e 's/DB_USERNAME=myuser/DB_USERNAME=$ENV{"H5_DB_USERNAME"}/' /var/www/html/.env
perl -pi -e 's/DB_PASSWORD=mypassword/DB_PASSWORD=$ENV{"H5_DB_PASSWORD"}/' /var/www/html/.env

# 启动 Apache
apache2-foreground
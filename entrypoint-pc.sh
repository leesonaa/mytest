#!/bin/bash

# 替换 PC 端配置文件中的数据库连接信息
sed -i "s/\$db['default']['hostname'] = 'localhost';/\$db['default']['hostname'] = '${DB_HOST}';/" /var/www/html/application/config/database.php
sed -i "s/\$db['default']['username'] = 'root';/\$db['default']['username'] = '${DB_USERNAME}';/" /var/www/html/application/config/database.php
sed -i "s/\$db['default']['password'] = '';/\$db['default']['password'] = '${DB_PASSWORD}';/" /var/www/html/application/config/database.php
sed -i "s/\$db['default']['database'] = 'mydatabase';/\$db['default']['database'] = '${DB_DATABASE}';/" /var/www/html/application/config/database.php

# 启动 Apache
apache2-foreground
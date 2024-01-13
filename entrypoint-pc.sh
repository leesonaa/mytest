#!/bin/bash

# 替换 PC 端配置文件中的数据库连接信息
perl -pi -e 's/\$db\['\''default'\''\]\['\''hostname'\''\] = '\''localhost'\'';/\$db['\''default'\'']['\''hostname'\''] = '\''$ENV{"DB_HOST"}'\'';/g' /var/www/html/application/config/database.php
perl -pi -e 's/\$db\['\''default'\''\]\['\''username'\''\] = '\''root'\'';/\$db['\''default'\'']['\''username'\''] = '\''$ENV{"DB_USERNAME"}'\'';/g' /var/www/html/application/config/database.php
perl -pi -e 's/\$db\['\''default'\''\]\['\''password'\''\] = '\'''\'';/\$db['\''default'\'']['\''password'\''] = '\''$ENV{"DB_PASSWORD"}'\'';/g' /var/www/html/application/config/database.php
perl -pi -e 's/\$db\['\''default'\''\]\['\''database'\''\] = '\''mydatabase'\'';/\$db['\''default'\'']['\''database'\''] = '\''$ENV{"DB_DATABASE"}'\'';/g' /var/www/html/application/config/database.php

# 启动 Apache
apache2-foreground
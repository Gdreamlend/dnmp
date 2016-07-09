#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh



if [ ! -d /web/www/default ] ; then
  echo "**********************************************************************************************************************"
  echo "运行容器时没有挂载www目录,自动创建目录和文件"
  mkdir -p /web/www/default
  echo "<?php phpinfo(); ?>" >> /web/www/default/index.php
  echo "**********************************************************************************************************************"
fi

# create all mysql neccessary database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo "**********************************************************************************************************************"
  echo "没有发现数据库,初始化数据库"
  echo "**********************************************************************************************************************"
  mysql_install_db --user=root > /dev/null

  if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
  fi

  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
EOF

  if [ "$MYSQL_DATABASE" != "" ]; then
    echo "**********************************************************************************************************************"
    echo "[i] Creating database: app_tests"
    echo "CREATE DATABASE IF NOT EXISTS \`app_tests\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    if [ "$MYSQL_USER" != "" ]; then
      echo "[i] Creating user: admin with password admin"
      echo "**********************************************************************************************************************"
      echo "GRANT ALL ON \`admin\`.* to 'admin'@'%' IDENTIFIED BY 'admin';" >> $tfile
    fi
  fi

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile

##################################
fi


echo "**********************************************************************************************************************"
echo "Starting PHP-FPM ..."
mkdir -p /web/logs/php-fpm
php-fpm7
echo "**********************************************************************************************************************"


echo "**********************************************************************************************************************"
echo "Starting Nginx ..."
mkdir -p /web/logs/nginx
mkdir -p /tmp/nginx
chown -R nginx:nginx /tmp/nginx
nginx
echo "**********************************************************************************************************************"


echo "**********************************************************************************************************************"
echo "Starting MySQL ..."
mysqld
echo "**********************************************************************************************************************"

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
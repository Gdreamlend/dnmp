#!/bin/sh

hr=''
prefix='▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ '



# 如果用户挂载的nginx配置目录没有文件
if [ ! -f /etc/nginx/conf.d/* ] ; then
    cp /default.conf /etc/nginx/conf.d/
    if [ ! -d /web/www ] ; then
      echo $hr
      echo "$prefix 没有挂载www目录, 使用默认..."
      echo $hr
      mkdir -p /web/www
      echo "<?php phpinfo(); ?>" >> /web/www/index.php
    fi
fi



# create all mysql database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo $hr
  echo "$prefix 挂载的数据库目录下没有数据库, 初始化数据库..."
  echo $hr
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
    echo $hr
    echo "[i] Creating database: app_tests"
    echo "CREATE DATABASE IF NOT EXISTS \`app_tests\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
    echo $hr

    if [ "$MYSQL_USER" != "" ]; then
      echo $hr
      echo "[i] Creating user: admin with password admin"
      echo "GRANT ALL ON \`admin\`.* to 'admin'@'%' IDENTIFIED BY 'admin';" >> $tfile
      echo $hr
    fi
  fi

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile

##################################
fi



echo $hr
echo "$prefix 启动 PHP-FPM ..."
mkdir -p /web/logs/php-fpm
php-fpm



echo $hr
echo "$prefix 启动 Nginx ..."
mkdir -p /web/logs/nginx
mkdir -p /tmp/nginx
chown -R nginx:nginx /tmp/nginx
nginx



echo $hr
echo "$prefix 启动 MySQL ..."
mysqld

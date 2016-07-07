#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /web/www ] ; then
  echo "Create HTDOCS"
  mkdir -p /web/www
  chown :www-data /web/www
fi

# create all mysql neccessary database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo "Installing MYSQL"
  # mysql_install_db
##################################
  echo "[i] MySQL data directory not found, creating initial DBs"

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
    echo "[i] Creating database: app_tests"
    echo "CREATE DATABASE IF NOT EXISTS \`app_tests\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    if [ "$MYSQL_USER" != "" ]; then
      echo "[i] Creating user: admin with password admin"
      echo "GRANT ALL ON \`admin\`.* to 'admin'@'%' IDENTIFIED BY 'admin';" >> $tfile
    fi
  fi

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile

##################################
fi

echo "STARTING PHP-FPM"
mkdir -p /web/logs/php-fpm
php-fpm

echo "STARTING NGINX"
mkdir -p /web/logs/nginx
mkdir -p /web/logs/php-fpm
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx

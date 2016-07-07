FROM alpine:3.4

ENV TERM xterm

RUN apk update 

RUN apk add curl wget openrc git mysql mysql-client bash nginx ca-certificates php5-fpm \
            php5-json php5-zlib php5-xml php5-pdo php5-phar php5-openssl php5-pdo_mysql \
            php5-mysqli php5-gd php5-iconv php5-mcrypt php5-curl php5-openssl php5-json php5-dom php5-ctype
RUN apk add -u musl
  
RUN mkdir -p /var/lib/mysql
RUN mkdir -p /etc/mysql/conf.d
RUN mkdir -p /var/run/mysql/
  
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN rm -rf /var/cache/apk/*

ADD Dockerfiles/nginx.conf     /etc/nginx/
ADD Dockerfiles/php-fpm.conf   /etc/php/
ADD Dockerfiles/my.cnf         /etc/mysql/
ADD Dockerfiles/run.sh         /

RUN chmod +x /run.sh

EXPOSE 80 443
EXPOSE 3306
WORKDIR /data/htdocs
VOLUME ["/etc/nginx/conf.d", "/web/www", "/web/logs", "/var/lib/mysql", "/etc/mysql/conf.d/"]
CMD ["/run.sh"]

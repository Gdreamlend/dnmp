# Docker Nginx Mysql PHP

PACKAGE YOUR APPLICATION INTO A STANDARDIZED UNIT FOR SOFTWARE DEVELOPMENT

Package Included
--------------------
- Nginx(1.8.0)
- PHP-fpm(5.6.15)
- Mysql(mariadb 10.1.8)
- Composer
- Git
- SSH

Quickly build & run for Mac / Linux
-----

```
  ./build.sh
```

If your OS is Windows, ensure that `Git Bash` is installed before running `build.sh`.


Build
-----

```
docker build -t dnmp .
```


Run in Windows
-----

```
  docker run -d \
  --name dnmp \
  -p 80:80 \
  -v d:/dnmp/conf.d:/etc/nginx/conf.d \
  -v d:/web/mysql:/var/lib/mysql \
  -v d:/web/logs:/web/logs \
  -v d:/web/www:/web/www \
  dnmp
```


Run in Mac or Linux
-----

```
docker run -d \
  --name dnmp \
  -p 80:80 \
  -v ~/dnmp/conf.d:/etc/nginx/conf.d \
  -v ~/web/mysql:/var/lib/mysql \
  -v ~/web/logs:/web/logs \
  -v ~/web/www:/web/www \
  dnmp
```

  Credits
----------

- https://github.com/reidniu/dnmp

# Docker Nginx Mysql PHP


Package Included
--------------------
- nginx(1.8.0)
- php-fpm(5.6.15)
- mysql(mariadb 10.1.8)
- composer


Quickly build & run in Windows
-----

```
  build.bat name<name> 80<port>
```


Quickly build & run in Mac or Linux
-----

```
  ./build.sh name<name> 80<port>
```


Build
-----

```console
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

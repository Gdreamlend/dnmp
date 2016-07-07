# Docker Nginx Mysql PHP


Package Included
--------------------

- alpine(3.4)
- git
- nginx(1.8.0)
- php-fpm(5.6.15)
- mysql(mariadb 10.1.8)
- composer

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
  -v d:/data/mysql:/var/lib/mysql \
  -v d:/data/logs:/data/logs \
  -v d:/data/www:/data/www \
  dnmp
```

Run in Mac Or Linux
-----

```
docker run -d \
  --name dnmp \
  -p 80:80 \
  -v /dnmp/conf.d:/etc/nginx/conf.d \
  -v /data/mysql:/var/lib/mysql \
  -v /data/logs:/data/logs \
  -v /data/www:/data/www \
  dnmp
```

  Credits
----------

- https://github.com/reidniu/dnmp

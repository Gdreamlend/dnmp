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
  -v d:/dnmp/mysql:/var/lib/mysql \
  -v d:/dnmp/logs:/data/logs \
  -v d:/dnmp/www:/data/www \
  dnmp
```

Run in Mac Or Linux
-----

```
docker run -d \
  --name dnmp \
  -p 80:80 \
  -v $PWD/conf.d:/etc/nginx/conf.d \
  -v $PWD/mysql:/var/lib/mysql \
  -v $PWD/logs:/data/logs \
  -v $PWD/www:/data/www \
  dnmp
```

  Credits
----------

- https://github.com/reidniu/dnmp

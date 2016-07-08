#!/bin/bash

echo "强制删除已有的容器"
docker rm -f dnmp

echo "强制删除已有的镜像"
docker rmi -f dnmp

echo "创建dnmp镜像"
docker build -t dnmp .


if [ ! -d nginx.conf ] ; then
  echo "nginx配置目录不存，创建并复制默认配置文件..."
  mkdir nginx.conf
  cp conf/default.conf nginx.conf/
fi


if [ ! -d www ] ; then
  echo "www目录不存在，创建并复制默认站点主页文件..."
  mkdir -p www/default
  cp conf/index.php www/default/
fi


if [ ! -d logs ] ; then
  echo "logs目录不存在，创建..."
  mkdir logs
fi


if [ ! -d mysql ] ; then
  echo "mysql目录不存，就创建..."
  mkdir mysql
fi

echo "根据镜像创建容器，运行并挂载目录"
docker run -d \
  -p 80:80 \
  --name dnmp \
  -v $PWD/nginx.conf:/etc/nginx/conf.d \
  -v $PWD/mysql:/var/lib/mysql \
  -v $PWD/logs:/web/logs \
  -v $PWD/www:/web/www \
  dnmp

echo "显示当前的镜像列表"
docker images

echo "显示当前容器的进程"
docker ps

echo "输出容器的日志"
docker logs dnmp

#!/bin/bash

echo "强制删除已有的容器"
docker rm -f dnmp

echo "强制删除已有的镜像"
docker rmi -f dnmp

echo "创建dnmp镜像"
docker build -t dnmp .

echo "若nginx配置目录不存在就创建，并复制默认配置文件"
if [ ! -d nginx.conf ] ; then
  mkdir nginx.conf
  cp conf/default.conf nginx.conf/
fi

echo "若www目录不存在就创建，并复制默认站点主页文件"
if [ ! -d www ] ; then
  mkdir -p www/default
  cp conf/index.php www/default/
fi

echo "若logs目录不存在就创建"
if [ ! -d logs ] ; then
  mkdir logs
fi

echo "若mysql目录不存在就创建"
if [ ! -d mysql ] ; then
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

#!/bin/bash
echo "******************************"
echo "强制删除已有的容器"
echo "******************************"
docker rm -f dnmp

echo "******************************"
echo "强制删除已有的镜像"
echo "******************************"
docker rmi -f dnmp

echo "******************************"
echo "创建dnmp镜像"
echo "******************************"
docker build -t dnmp .


if [ ! -d nginx.conf ] ; then
  echo "******************************"
  echo "nginx配置目录不存，创建并复制默认配置文件..."
  echo "******************************"
  mkdir nginx.conf
  cp conf/default.conf nginx.conf/
fi


if [ ! -d www ] ; then
  echo "******************************"
  echo "www目录不存在，创建并复制默认站点主页文件..."
  echo "******************************"
  mkdir -p www/default
  cp conf/index.php www/default/
fi


if [ ! -d logs ] ; then
  echo "******************************"
  echo "logs目录不存在，创建..."
  echo "******************************"
  mkdir logs
fi


if [ ! -d mysql ] ; then
  echo "******************************"
  echo "mysql目录不存，就创建..."
  echo "******************************"
  mkdir mysql
fi

echo "******************************"
echo "根据镜像创建容器，运行并挂载目录"
echo "******************************"
docker run -d \
  -p 80:80 \
  --name dnmp \
  -v $PWD/nginx.conf:/etc/nginx/conf.d \
  -v $PWD/mysql:/var/lib/mysql \
  -v $PWD/logs:/web/logs \
  -v $PWD/www:/web/www \
  dnmp

echo "******************************"
echo "显示当前的镜像列表"
echo "******************************"
docker images

echo "******************************"
echo "显示当前容器的进程"
echo "******************************"
docker ps

echo "******************************"
echo "输出容器的日志"
echo "******************************"
docker logs dnmp

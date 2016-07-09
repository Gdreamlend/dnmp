#!/bin/bash

if [ $1 ]; then
       pname=$1
       echo "————————————————————————————————"
       echo "  项目名称为 $pname "
       echo "————————————————————————————————"
       else
       pname='web'
       echo "————————————————————————————————"
       echo "  没有定义项目名, 默认为 $pname "
       echo "————————————————————————————————"
fi

echo "————————————————————————————————"
echo "  删除已有 $pname 容器"
echo "————————————————————————————————"
docker rm -f $pname

echo "————————————————————————————————"
echo "  删除已有 $pname 镜像"
echo "————————————————————————————————"
docker rmi -f $pname

echo "————————————————————————————————"
echo "  创建 $pname 镜像"
echo "————————————————————————————————"
docker build -t $pname .


if [ ! -d ../$pname/nginx ] ; then
  echo "————————————————————————————————"
  echo "  Nginx配置目录不存在，使用默认..."
  echo "————————————————————————————————"
  mkdir ../$pname/nginx
  cp conf/default.conf ../$pname/nginx/default.conf
fi


if [ ! -d ../$pname/www ] ; then
  echo "————————————————————————————————"
  echo "  www目录不存在，使用默认..."
  echo "————————————————————————————————"
  mkdir -p ../$pname/www/default
  cp conf/index.php ../$pname/www/default/
fi


if [ ! -d ../$pname/logs ] ; then
  echo "————————————————————————————————"
  echo "  Logs目录不存在，创建..."
  echo "————————————————————————————————"
  mkdir ../$pname/logs
fi


if [ ! -d ../$pname/mysql ] ; then
  echo "————————————————————————————————"
  echo "  Mysql目录不存，创建..."
  echo "————————————————————————————————"
  mkdir ../$pname/mysql
fi

echo "————————————————————————————————"
echo "  创建 $pname 容器，运行并挂载目录 "
echo "————————————————————————————————"

if [ $2 ]; then
       port=$2
       echo "端口为 $port "
       else
       port=80
       echo "没有定义端口, 默认为 $port "
fi

docker run -d \
  -p 80:${port} \
  --name $pname \
  -v $PWD/../$pname/nginx:/etc/nginx/conf.d \
  -v $PWD/../$pname/mysql:/var/lib/mysql \
  -v $PWD/../$pname/logs:/web/logs \
  -v $PWD/../$pname/www:/web/www \
  $1

echo "————————————————————————————————"
echo "    显示当前的镜像列表"
echo "————————————————————————————————"
docker images

echo "————————————————————————————————"
echo "    显示当前容器的进程"
echo "————————————————————————————————"
docker ps

echo "————————————————————————————————"
echo "    输出 $pname 容器日志"
echo "————————————————————————————————"
docker logs $pname
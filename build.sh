#!/bin/bash

hr='————————————————————————————————————————————————'
prefix='|              '
if [ $1 ]; then
       pname=$1
       echo $hr
       echo "$prefix 项目名称为 $pname "
       echo $hr
       else
       pname='web'
       echo $hr
       echo "$prefix 没有定义项目名, 默认为 $pname "
       echo $hr
fi

echo $hr
echo "$prefix 删除已有 $pname 容器"
echo $hr
docker rm -f $pname

echo $hr
echo "$prefix 删除已有 $pname 镜像"
echo $hr
docker rmi -f $pname

echo $hr
echo "$prefix 创建 $pname 镜像"
echo $hr
docker build -t $pname .


if [ ! -d ../$pname/nginx ] ; then
  echo $hr
  echo "$prefix Nginx配置目录不存在，使用默认..."
  echo $hr
  mkdir ../$pname/nginx
  cp conf/default.conf ../$pname/nginx/default.conf
fi


if [ ! -d ../$pname/www ] ; then
  echo $hr
  echo "$prefix www目录不存在，使用默认..."
  echo $hr
  mkdir -p ../$pname/www/default
  cp conf/index.php ../$pname/www/default/
fi


if [ ! -d ../$pname/logs ] ; then
  echo $hr
  echo "$prefix Logs目录不存在，创建..."
  echo $hr
  mkdir ../$pname/logs
fi


if [ ! -d ../$pname/mysql ] ; then
  echo $hr
  echo "$prefix Mysql目录不存，创建..."
  echo $hr
  mkdir ../$pname/mysql
fi

echo $hr
echo "$prefix 创建 $pname 容器，运行并挂载目录 "
echo $hr

if [ $2 ]; then
           port=$2
           echo $hr
           echo "$prefix 端口为 $port "
           echo $hr
       else
           port=80
           echo $hr
           echo "$prefix 没有定义端口, 默认为 $port "
           echo $hr
fi

docker run -d \
  -p 80:${port} \
  --name $pname \
  -v $PWD/../$pname/nginx:/etc/nginx/conf.d \
  -v $PWD/../$pname/mysql:/var/lib/mysql \
  -v $PWD/../$pname/logs:/web/logs \
  -v $PWD/../$pname/www:/web/www \
  $pname

echo $hr
echo "$prefix 显示当前的镜像列表"
echo $hr
docker images

echo $hr
echo "$prefix 显示当前容器的进程"
echo $hr
docker ps

echo $hr
echo "$prefix 输出 $pname 容器日志"
echo $hr
docker logs $pname
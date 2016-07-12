#!/bin/bash
hr=''
prefix='▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ '



echo ''
echo ''
echo $hr
echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"
echo ''
echo "                                      欢迎使用 DNMP 系统"
echo ''
echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"


while :; do echo
    read -p "请输入项目英文名: " pname
    [ -n "$pname" ] && break
done


while :; do echo
read -p "Windows:1    Mac/Linux:2    请选择: " SYS
[[ $SYS == '1' || $SYS == '2' ]] && break
done

if [ $SYS == '1' ]
then
  datadir='d:/dnmp-'$pname
else
  datadir=$PWD'/../dnmp-'$pname
fi


if [ -d $datadir ] ; then
  echo $hr
  echo "$prefix $pname 已存在, 怎么办? $prefix"
  echo $hr
      while :; do echo
          read -p "仅重建升级环境:1    删除web数据后重建升级环境:2    取消操作:3    请选择: " YES
          if [[ $YES == '1' || $YES == '2' ]]
          then
            echo $hr
            echo "$prefix 删除已有 $pname 容器和镜像 $prefix"
            echo $hr
            docker rm -f $pname || true
            docker rmi -f $pname || true

               if [ $YES == '2' ] ; then
                 echo $hr
                 echo "$prefix 删除 $pname 数据文件 $prefix"
                 echo $hr
                 rm -rf $datadir
               fi
               break
           fi

           if [ $YES == '3' ] ; then
           echo $hr
           echo "$prefix 有缘再见  $prefix"
           echo $hr
           exit
           fi
      done
fi






function isint () {
    if [ $# -lt 1 ]; then
        return 0
    fi

    if [[ $1 =~ ^-?[1-9][0-9]*$ ]]; then
        return 1
    fi

    if [[ $1 =~ ^0$ ]]; then
        return 1
    fi

    return 0
}


echo $hr
echo "$prefix 配置端口号 $prefix"
while :; do echo
    read -p "请输入端口号: " port
    isint $port
    [ $? == '1' ]  && break
done






echo $hr
echo "$prefix 拉取 DNMP 基本镜像 $prefix"
echo $hr
docker pull reidniu/dnmp:latest


if [ ! -d $datadir/nginx ] ; then
  echo $hr
  echo "$prefix Nginx配置目录不存在，使用默认... $prefix"
  echo $hr
  mkdir -p $datadir/nginx
  cp conf/default.conf $datadir/nginx/
fi


if [ ! -d $datadir/www ] ; then
  echo $hr
  echo "$prefix www目录不存在，使用默认... $prefix"
  echo $hr
  mkdir -p $datadir/www
  cp conf/index.php $datadir/www
fi


if [ ! -d $datadir/logs ] ; then
  echo $hr
  echo "$prefix Logs目录不存在，创建... $prefix"
  echo $hr
  mkdir -p $datadir/logs
fi


if [ ! -f $datadir/mysql/ibdata1 ] ; then
  echo $hr
  echo "$prefix Mysql目录不存在，创建... $prefix"
  echo $hr
  mkdir -p $datadir/mysql
  echo $hr
  echo "$prefix Mysql创建成功，Root密码为空 $prefix"
  echo $hr
fi


echo $hr
echo "$prefix 当前的镜像列表 $prefix"
echo $hr
docker images



echo $hr
echo "$prefix 运行 $pname 并挂载目录 $prefix"
echo $hr


docker run -d \
  -p 80:${port} \
  --name $pname \
  -v $datadir/nginx:/etc/nginx/conf.d \
  -v $datadir/mysql:/var/lib/mysql \
  -v $datadir/logs:/web/logs \
  -v $datadir/www:/web/www \
  reidniu/dnmp:latest


echo $hr
echo "$prefix 当前容器列表 $prefix"
echo $hr
docker ps -a



echo $hr
echo "$prefix SSH 登录 $pname $prefix"
docker exec -it $pname bash
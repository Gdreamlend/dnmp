#!/bin/bash

lenovo='
        !;;;;;;!
        ;:;:::;-
       ,:;;:::;
       ;;;;;;:!
       ;;;;;;:;
       :;;;;::.
      -:;;;;:;      .;!;;;;:;!~       ,:;!;;;;;;;;!;-         .:!;;:;;;;;,   .;;;;;;~      ~;;;;;;;    ,:!;:;;;:!;.
      ;:;;;;:;    :;;:;::;::;:;;:   ;:;;;;:;;::::;;:;;:     :;;;::::::;;;;!-  :;;:::;      ;:;;;:;  .!;;;:::::;:;:;!
      ;:;;;;:-  ,;:;::!.  .;:;:::-  ;::;;;:;.,,;:;;::::.  ,;:;:;;;,.~;;;;;:;- ;;;:;:;     ;::;:::, :;::;:;:..;:;;:::;
     .:;;;;;;  -;:;;:!     -:;:::;  ;;:;;;:.   .;;;;;;:. ~:::;::!    ;:;;;::; ;;:;;;:    ::::;;:; ;:;;;;:~    ;;;;;;:!
     ;:;;;;;;  ;;;:;;~     ~:;;;;; ~:;:;;;;    ~:;;;;;; .;;;;;:;     :;;;:;;; !::;;;;   .;;;:;:! ;;;:;:::     ;;;;;;;;
     !:;;;;;: ;;;;;:;    -;;;:::;! !:;:;;:!    ;:;;;;;; !:;;;;:!     ;;;;:;:; ;::;;;;   ;;;;;::. ;;;:::;-     ;;;;;;:;
     ;;:;;;;. ;:;;;;;  ,;:::;!:,   ;;;;;::-    ;:;;;;;- ;:;;;;;,     ;;;;;;:; ~:;;;;:. ;:;;;;:: ;::;;:;;      ;;;;;;:;
    -:;:;;;; -;:;;;;:,!:;;:.      ,;;;;;:;    ,;;;;;;; ;::;;;:;      ;;;;;::~ -:;;;;:-,:;;;;;;  ;;::;::!     ::;;;;;;
    !:;;:::; ::;;;;;;;~.          :;;;:;:!    ::;;:;:; ::;;;;:;     ;;;::;:;  .:;;;;;~;;;:::;.  ;;:;;:;!     :;::;;;;
    ;;:;;:;- -:;;;;:,       ,;;   ;;;;:;:~    ;;;;:;:~ ~::;;;;;     ;::;;;!    :;;;;;;;;;;:;:   ;::;;:;!    ~:;:;::;
    ;;;;;:;   ;::;;;;-. .-;;::,  .:;;;;;;    .;;;;;:;   !:;:;::!. -;:;:::;     ;:;;;;;;;;;:!     ;:;;;;;:  :;:;;:;;
   ;:;;:;:;   ,;;;;;::;:;::;;!   ::;;;;:;    :;;;;;:;    !;;;;::;:;::;;!-      ;;;;;;:::;;;      ,!:;;;:;:;::;:;;.
   *;;;;!;;     ~;;:::;:;;;:,    !;;;;;;;    !;;;;;;!     .;;;;:::;;;:         !;;;;;;;;;;:        -;;;:;;;;;;~

'
hr=''
hr2='▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇'
prefix='▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇'

echo ''
echo ''
echo $hr
echo "$prefix 欢迎使用联想DNMP系统! $prefix"


while :; do echo
    read -p "请输入镜像、容器、项目的共同名称: " pname
    [ -n "$pname" ] && break
done







if [ -d ../$pname ] ; then
  echo $hr
  echo "$prefix $pname 已存在, 重建或升级镜像和容器?  $prefix"
  echo "$prefix 重建或升级不会影响你的项目数据!  $prefix"
  echo $hr
      while :; do echo
        read -p "重建或升级(Y/N): " YES
        [ -n "$YES" ] && break
      done
fi



if [  $YES!='Y' ] ; then
  echo "$prefix 有缘再见  $prefix"
  echo $YES
  echo $hr
  exit
fi


while :; do echo
    read -p "请输入端口号: " port
    [ -n "$port" ] && break
done


echo $hr
echo "$prefix 项目 $pname 的端口为 $port  $prefix"


echo $hr
echo "$prefix 删除已有 $pname 容器 $prefix"
echo $hr
docker rm -f $pname

echo $hr
echo "$prefix 删除已有 $pname 镜像 $prefix"
echo $hr
docker rmi -f $pname

echo $hr
echo "$prefix 创建 $pname 镜像 $prefix"
echo $hr
docker build -t $pname .


if [ ! -d ../$pname/nginx ] ; then
  echo $hr
  echo "$prefix Nginx配置目录不存在，使用默认... $prefix"
  echo $hr
  mkdir ../$pname/nginx
  cp conf/default.conf ../$pname/nginx/default.conf
fi


if [ ! -d ../$pname/www ] ; then
  echo $hr
  echo "$prefix www目录不存在，使用默认... $prefix"
  echo $hr
  mkdir -p ../$pname/www/default
  cp conf/index.php ../$pname/www/default/
fi


if [ ! -d ../$pname/logs ] ; then
  echo $hr
  echo "$prefix Logs目录不存在，创建... $prefix"
  echo $hr
  mkdir ../$pname/logs
fi


if [ ! -d ../$pname/mysql ] ; then
  echo $hr
  echo "$prefix Mysql目录不存，创建... $prefix"
  echo $hr
  mkdir ../$pname/mysql
fi

echo $hr
echo "$prefix 创建 $pname 容器，运行并挂载目录 $prefix"
echo $hr



docker run -d \
  -p 80:${port} \
  --name $pname \
  -v $PWD/../$pname/nginx:/etc/nginx/conf.d \
  -v $PWD/../$pname/mysql:/var/lib/mysql \
  -v $PWD/../$pname/logs:/web/logs \
  -v $PWD/../$pname/www:/web/www \
  $pname

echo $hr
echo "$prefix 显示当前的镜像列表 $prefix"
echo $hr
docker images

echo $hr
echo "$prefix 显示当前容器的进程 $prefix"
echo $hr
docker ps



echo $hr
echo "$prefix 登录 $pname 服务器 $prefix"
docker exec -it $pname bash


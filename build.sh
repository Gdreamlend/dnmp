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
prefix='▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ '

echo ''
echo ''
echo $hr
echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"
echo ''
echo "                                              欢迎使用联想DNMP系统"
echo ''
echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇"


while :; do echo
    read -p "请输入项目英文名: " pname
    [ -n "$pname" ] && break
done







if [ -d data/$pname ] ; then
  echo $hr
  echo "$prefix 此项目已存在, 重建或升级镜像和容器?  $prefix"
  echo "$prefix 重建或升级不会影响你的私有项目数据!  $prefix"
  echo $hr
      while :; do echo
        read -p "重建或升级(Y/N): " YES
        [ -n "$YES" ] && break
      done

      if [ $YES == 'Y' ]
      then
        echo $hr
        echo "$prefix 删除已有 $pname 容器 $prefix"
        echo $hr
        docker rm -f $pname

        echo $hr
        echo "$prefix 删除已有 $pname 镜像 $prefix"
        echo $hr
        docker rmi -f $pname
      else
        echo $hr
        echo "$prefix 有缘再见  $prefix"
        echo $hr
        exit
      fi

fi




echo $hr
echo "$prefix 配置端口号 $prefix"

while :; do echo
    read -p "请输入端口号: " port
    [ -n "$port" ] && break
done


echo $hr
echo "$prefix 创建 $pname 镜像 $prefix"
echo $hr
docker build -t $pname .


if [ ! -d data/$pname/nginx ] ; then
  echo $hr
  echo "$prefix Nginx配置目录不存在，使用默认... $prefix"
  echo $hr
  mkdir -p data/$pname/nginx
  cp conf/default.conf data/$pname/nginx/
fi


if [ ! -d data/$pname/www ] ; then
  echo $hr
  echo "$prefix www目录不存在，使用默认... $prefix"
  echo $hr
  mkdir -p data/$pname/www/default
  cp conf/index.php data/$pname/www/default/
fi


if [ ! -d data/$pname/logs ] ; then
  echo $hr
  echo "$prefix Logs目录不存在，创建... $prefix"
  echo $hr
  mkdir -p data/$pname/logs
fi


if [ ! -d data/$pname/mysql ] ; then
  echo $hr
  echo "$prefix Mysql目录不存，创建... $prefix"
  echo $hr
  mkdir -p data/$pname/mysql
fi


echo $hr
echo "$prefix 显示当前的镜像列表 $prefix"
echo $hr
docker images



echo $hr
echo "$prefix 运行 $pname 容器并挂载本地目录 $prefix"
echo $hr


docker run -d \
  -p 80:${port} \
  --name $pname \
  -v $PWD/data/$pname/nginx:/etc/nginx/conf.d \
  -v $PWD/data/$pname/mysql:/var/lib/mysql \
  -v $PWD/data/$pname/logs:/web/logs \
  -v $PWD/data/$pname/www:/web/www \
  $pname



echo $hr
echo "$prefix 显示当前容器的进程 $prefix"
echo $hr
docker ps



echo $hr
echo "$prefix SSH 登录 $pname 服务器 $prefix"
docker exec -it $pname bash


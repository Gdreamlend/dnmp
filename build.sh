docker rm -f dnmp
docker rmi -f dnmp
docker build -t dnmp .

# 如果www目录已经存在，就不创建默认文件
if [ ! -d www ] ; then
  mkdir -p mysql logs
  mkdir -p www/default
  cp conf/index.php www/default/
fi



docker run -d \
  -p 80:80 \
  --name dnmp \
  -v $PWD/nginx.conf:/etc/nginx/conf.d \
  -v $PWD/mysql:/var/lib/mysql \
  -v $PWD/logs:/web/logs \
  -v $PWD/www:/web/www \
  dnmp


docker images
docker ps
docker logs dnmp

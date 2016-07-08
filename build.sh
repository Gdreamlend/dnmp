docker rm -f dnmp
docker rmi -f dnmp
docker build -t dnmp .

mkdir mysql logs www

docker run -d \
  -p 80:80 \
  --name dnmp \
  -v $PWD/conf.d:/etc/nginx/conf.d \
  -v $PWD/mysql:/var/lib/mysql \
  -v $PWD/logs:/web/logs \
  -v $PWD/www:/web/www \
  dnmp

docker images
docker ps
docker logs dnmp

docker rm -f dnmp
docker rmi -f dnmp
docker build -t dnmp .
docker run -d \
  -p 80:80 \
  --name dnmp \
  -v d:/dnmp/conf.d:/etc/nginx/conf.d \
  -v d:/web/mysql:/var/lib/mysql \
  -v d:/web/logs:/web/logs \
  -v d:/web/www:/web/www \
  dnmp
docker images
docker ps
docker logs dnmp

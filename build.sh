docker rm -f dnmp
docker rmi -f dnmp
docker build -t dnmp .
docker run -d \
  -p 80:80 \
  --name dnmp \
  -v /web/conf.d:/etc/nginx/conf.d \
  -v /web/mysql:/var/lib/mysql \
  -v /web/logs:/web/logs \
  -v /web/www:/web/www \
  dnmp
docker ps
docker logs dnmp

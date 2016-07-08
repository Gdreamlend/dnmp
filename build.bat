docker rm -f dnmp
docker rmi -f dnmp
docker build -t dnmp .

mkdir mysql logs www

docker run -d \
  -p 80:80 \
  --name dnmp \
  -v ./conf.d:/etc/nginx/conf.d \
  -v ./mysql:/var/lib/mysql \
  -v ./logs:/web/logs \
  -v ./www:/web/www \
  dnmp
docker images
docker ps
docker logs dnmp

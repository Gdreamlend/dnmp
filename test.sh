#!/usr/bin/env bash
docker rm -f test
docker rmi -f test
docker build -t test .
docker run -d -t --name test -p 80:80 test
docker exec -it test bash
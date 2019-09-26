#!/bin/bash

cd /home/bitnami/htdocs/nav-session-service/src && git pull origin master
cd /home/bitnami/htdocs/tag-service/src && git pull origin master
cd /home/bitnami/htdocs/webchat-service/src && git pull origin master

cp /home/bitnami/htdocs/Envs/nav-session-service.env /home/bitnami/htdocs/nav-session-service/src/.env
cp /home/bitnami/htdocs/Envs/tag-service.env /home/bitnami/htdocs/tag-service/src/.env
cp /home/bitnami/htdocs/Envs/webchat-service.env /home/bitnami/htdocs/webchat-service/src/.env

sudo docker build -t polichat/nav-session-service:1.0 /home/bitnami/htdocs/nav-session-service/src/.
sudo docker build -t polichat/tag-service:1.0 /home/bitnami/htdocs/tag-service/src/.
sudo docker build -t polichat/webchat-service:1.0 /home/bitnami/htdocs/webchat-service/src/.

sudo docker stop mongodb

sudo docker rm mongodb

sudo docker run -v /home/bitnami/htdocs/database/mongo:/data/db -d -p 27017:27017 --name mongodb mongo --auth

sudo docker stop nav-session-service
sudo docker stop tag-service
sudo docker stop webchat-service

sudo docker rm nav-session-service
sudo docker rm tag-service
sudo docker rm webchat-service

sudo docker run -d -p 3010:3010 --name nav-session-service -v /home/bitnami/htdocs/volumes/nav-session-service:/usr/app/logs/ polichat/nav-session-service:1.0
sudo docker run -d -p 3009:3009 --name tag-service -v /home/bitnami/htdocs/volumes/nav-session-service:/usr/app/logs/ polichat/tag-service:1.0
sudo docker run -d -p 3008:3008 -p 31000:31000 --name webchat-service -v /home/bitnami/htdocs/volumes/nav-session-service:/usr/app/logs/ polichat/webchat-service:1.0
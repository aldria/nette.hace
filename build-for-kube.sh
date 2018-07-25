#!/usr/bin/env bash

REMOTE_REPO_ADDR=192.168.0.101:5000

# app
IS_PROD_BUILD=0
PHP_INI=php-dev.ini

# webserver
WEBSERVER_NGINX_PORT=8000
WEBSERVER_NGINX_TEMPLATE=webserver.template.nginx

# spa
API_HOST=www.doveah.com
SPA_NGINX_PORT=8000
SPA_NGINX_TEMPLATE=spa.template.nginx


docker build -f Dockerfile \
    --build-arg IS_PROD_BUILD=$IS_PROD_BUILD \
    --build-arg PHP_INI=$PHP_INI \
    --tag ${REMOTE_REPO_ADDR}/srigi/hace/app \
    .

docker build -f Dockerfile.webserver \
    --build-arg WEBSERVER_NGINX_PORT=$WEBSERVER_NGINX_PORT \
    --build-arg WEBSERVER_NGINX_TEMPLATE=$WEBSERVER_NGINX_TEMPLATE \
    --tag ${REMOTE_REPO_ADDR}/srigi/hace/webserver \
    .

docker build -f Dockerfile.spa \
    --build-arg API_HOST=$API_HOST \
    --build-arg SPA_NGINX_PORT=$SPA_NGINX_PORT \
    --build-arg SPA_NGINX_TEMPLATE=$SPA_NGINX_TEMPLATE \
    --tag ${REMOTE_REPO_ADDR}/srigi/hace/spa \
    .

docker push ${REMOTE_REPO_ADDR}/srigi/hace/app
docker push ${REMOTE_REPO_ADDR}/srigi/hace/webserver
docker push ${REMOTE_REPO_ADDR}/srigi/hace/spa

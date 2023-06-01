#!/bin/bash

cd /home/service-web/back/

printf "       - .env\n" > env.txt

MYSQL_ROOT_PASSWORD=$(grep MYSQL_ROOT_PASSWORD docker-compose.yaml | awk '{print $2}')
MYSQL_DATABASE=$(grep MYSQL_DATABASE docker-compose.yaml | awk '{print $2}')
MYSQL_USER=$(grep MYSQL_USER docker-compose.yaml | awk '{print $2}')
MYSQL_PASSWORD=$(grep MYSQL_PASSWORD docker-compose.yaml | awk '{print $2}')

echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >>  .env
echo "MYSQL_DATABASE=$MYSQL_DATABASE" >> .env
echo "MYSQL_USER=$MYSQL_USER" >> .env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> .env

awk  'NR==10{print"      - .env"} NR!=10 && NR!=11 && NR!=12 &&NR!=13 {print $0} docker-compose.yml > docker-compose-new.yml
mv dock-compose-new.yml docker-compose.yml
rm env.txt
docker-compose up -d 
#!/bin/bash

echo "Остановка всех запущенных контейнеров..."
docker stop $(docker ps -aq)

echo "Удаление всех контейнеров..."
docker rm $(docker ps -aq)

echo "Удаление всех образов..."
docker rmi $(docker images -q)

echo "Удаление всех volumes..."
docker volume rm $(docker volume ls -q)

echo "Удаление всех сетей..."
docker network rm $(docker network ls -q)

echo "Все контейнеры, образы, volumes и сети были удалены."

#!/bin/bash

# Caminho da pasta com o Dockerfile e nginx.conf
PROXY_DIR="./proxy"
IMAGE_NAME="proxy-app"
CONTAINER_NAME="my-proxy-app"
PORT=4500

# Build da imagem Docker do NGINX proxy
echo "⏳ Buildando a imagem do proxy ($IMAGE_NAME)..."
docker build -t $IMAGE_NAME $PROXY_DIR

# Verifica se já existe um container com esse nome
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🛑 Parando e removendo container existente ($CONTAINER_NAME)..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Rodar o container com a porta correta
echo "🚀 Subindo o container proxy ($CONTAINER_NAME)..."
docker container run --name $CONTAINER_NAME -dti -p $PORT:$PORT $IMAGE_NAME

echo "✅ Proxy rodando em http://localhost:$PORT"
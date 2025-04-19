#!/bin/bash

# Caminho da pasta com o Dockerfile e banco.sql
MYSQL_DIR="./mysql_custom"
IMAGE_NAME="custom-mysql"
CONTAINER_NAME="mysql-db"
VOLUME_NAME="mysql-data"

# Criar a imagem personalizada do MySQL
echo "⏳ Buildando a imagem Docker personalizada ($IMAGE_NAME)..."
docker build -t $IMAGE_NAME $MYSQL_DIR

# Criar volume persistente
echo "📦 Criando volume Docker ($VOLUME_NAME)..."
docker volume create $VOLUME_NAME

# Rodar o container MySQL fora do Swarm
echo "🚀 Subindo container $CONTAINER_NAME..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 3306:3306 \
  -v $VOLUME_NAME:/var/lib/mysql \
  $IMAGE_NAME

echo "✅ MySQL container rodando na porta 3306!"
#!/bin/bash

# Definições
MANAGER_IP="192.168.0.104"
WORKER1_IP="192.168.0.105"
NFS_DIR_WEB="/srv/nfs/web"
NFS_DIR_MYSQL="/srv/nfs/mysql"

echo "[+] Instalando e configurando NFS (caso necessário)..."
sudo apt-get update -qq
sudo apt-get install -y nfs-kernel-server

sudo mkdir -p $NFS_DIR_WEB
sudo mkdir -p $NFS_DIR_MYSQL
sudo chmod 777 $NFS_DIR_WEB $NFS_DIR_MYSQL

grep -qF "$NFS_DIR_WEB" /etc/exports || echo "$NFS_DIR_WEB *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
grep -qF "$NFS_DIR_MYSQL" /etc/exports || echo "$NFS_DIR_MYSQL *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

sudo exportfs -rav
sudo systemctl restart nfs-kernel-server
echo "[✓] NFS configurado com sucesso!"

echo "[+] Inicializando Swarm..."
docker swarm init --advertise-addr $MANAGER_IP

SWARM_JOIN_CMD=$(docker swarm join-token worker -q)
FULL_JOIN_CMD="docker swarm join --token $SWARM_JOIN_CMD $MANAGER_IP:2377"

echo "[!] Copie e execute esse comando nas instâncias worker:"
echo $FULL_JOIN_CMD

read -p "[?] Pressione ENTER após adicionar os workers ao cluster..."

docker node ls

echo "[+] Preparando aplicação web..."
if [ -f ./index.php ]; then
    sudo cp ./index.php $NFS_DIR_WEB/
    echo "[✓] index.php copiado."
else
    echo "[!] index.php não encontrado!"
    exit 1
fi

echo "[+] Criando imagem customizada do MySQL..."
mkdir -p mysql-custom
cp banco.sql mysql-custom/bancodedados.sql

cat <<EOF > mysql-custom/Dockerfile
FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=testdb

COPY bancodedados.sql /docker-entrypoint-initdb.d/
EOF

docker build -t custom-mysql ./mysql-custom

echo "[+] Criando docker-compose.yml..."

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  php-web:
    image: php:8.2-cli
    command: php -S 0.0.0.0:8000 -t /var/www/html
    ports:
      - "8080:8000"
    volumes:
      - web-code:/var/www/html
    deploy:
      replicas: 2
      placement:
        constraints: [node.role == worker]

  mysql:
    image: custom-mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: testdb
    volumes:
      - mysql-data:/var/lib/mysql
    deploy:
      placement:
        constraints: [node.role == manager]

volumes:
  web-code:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=$MANAGER_IP,rw"
      device: ":$NFS_DIR_WEB"

  mysql-data:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=$MANAGER_IP,rw"
      device: ":$NFS_DIR_MYSQL"
EOF

echo "[+] Fazendo o deploy da stack..."
docker stack deploy -c docker-compose.yml app

echo "[✓] Deploy concluído! Verifique com: docker service ls"

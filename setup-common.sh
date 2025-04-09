#!/bin/bash

echo "[+] Atualizando sistema e instalando Docker..."
sudo apt update -y && sudo apt install -y docker.io nfs-common

echo "[+] Habilitando Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[+] Docker instalado:"
docker --version

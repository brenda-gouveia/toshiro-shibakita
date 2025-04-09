#!/bin/bash

echo "[+] Instalando NFS Server..."
sudo apt install -y nfs-kernel-server

echo "[+] Criando diretório NFS..."
sudo mkdir -p /srv/nfs/volume
sudo chown nobody:nogroup /srv/nfs/volume

echo "[+] Configurando /etc/exports..."
echo "/srv/nfs/volume *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

echo "[+] Reiniciando NFS Server..."
sudo exportfs -a
sudo systemctl restart nfs-kernel-server

echo "[+] NFS Server configurado."

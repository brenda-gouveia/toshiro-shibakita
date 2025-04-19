#!/bin/bash

# Definir as variáveis de IP dos nós
master_ip="IP_DO_MASTER"
worker_ips=("IP_WORKER1" "IP_WORKER2")

# Função para verificar e criar a pasta de destino nos nós (master e workers)
criar_pasta_destino() {
    echo "Verificando e criando a pasta /mnt/web nos nós..."
    todos_os_nos=($master_ip "${worker_ips[@]}")
    for ip in "${todos_os_nos[@]}"; do
        echo "Verificando nó $ip"
        ssh $ip "mkdir -p /mnt/web" 2>> /var/log/setup_cluster.log
        if [[ $? -ne 0 ]]; then
            echo "Erro ao criar a pasta /mnt/web no nó $ip" >> /var/log/setup_cluster.log
        else
            echo "Pasta /mnt/web criada no nó $ip" >> /var/log/setup_cluster.log
        fi
    done
}

# Função para garantir que as dependências necessárias estejam instaladas nos nós (master e workers)
instalar_dependencias() {
    echo "Instalando dependências nos nós..." >> /var/log/setup_cluster.log
    todos_os_nos=($master_ip "${worker_ips[@]}")
    for ip in "${todos_os_nos[@]}"; do
        echo "Instalando pacotes no nó $ip"
        ssh $ip "sudo apt-get update && sudo apt-get install -y nfs-common docker.io" >> /var/log/setup_cluster.log 2>&1
        if [[ $? -ne 0 ]]; then
            echo "Erro ao instalar dependências no nó $ip" >> /var/log/setup_cluster.log
        else
            echo "Dependências instaladas com sucesso no nó $ip" >> /var/log/setup_cluster.log
        fi
    done
}

# Inicializar o Docker Swarm no nó master
iniciar_swarm_master() {
    echo "Inicializando o Docker Swarm no nó master $master_ip..." >> /var/log/setup_cluster.log
    ssh $master_ip "docker swarm init --advertise-addr $master_ip" >> /var/log/setup_cluster.log 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Erro ao inicializar o Docker Swarm no nó master $master_ip" >> /var/log/setup_cluster.log
    else
        echo "Docker Swarm iniciado com sucesso no nó master $master_ip" >> /var/log/setup_cluster.log
    fi
}

# Adicionar nós workers ao cluster Docker Swarm
adicionar_nos_workers() {
    echo "Adicionando nós worker ao cluster..." >> /var/log/setup_cluster.log
    token=$(ssh $master_ip "docker swarm join-token worker -q")  # Obtém o token de worker
    for worker_ip in "${worker_ips[@]}"; do
        echo "Adicionando nó worker $worker_ip ao cluster..."
        ssh $worker_ip "docker swarm join --token $token $master_ip:2377" >> /var/log/setup_cluster.log 2>&1
        if [[ $? -ne 0 ]]; then
            echo "Erro ao adicionar nó worker $worker_ip ao cluster" >> /var/log/setup_cluster.log
        else
            echo "Nó worker $worker_ip adicionado com sucesso ao cluster" >> /var/log/setup_cluster.log
        fi
    done
}

# Criar serviço Docker no Swarm (com bind mount para /mnt/web)
criar_servico_docker() {
    echo "Criando o serviço Docker com bind mount para /mnt/web..." >> /var/log/setup_cluster.log
    docker service create \
        --name app_php-web \
        --replicas 2 \
        --mount type=bind,source=/mnt/web,target=/var/www/html \
        -p 8080:80 \
        php:8.2-apache \
        bash -c "docker-php-ext-install mysqli && apache2-foreground" >> /var/log/setup_cluster.log 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Erro ao criar o serviço Docker no cluster" >> /var/log/setup_cluster.log
    else
        echo "Serviço Docker criado com sucesso no cluster" >> /var/log/setup_cluster.log
    fi
}

# Função principal
main() {
    # Etapas do processo
    criar_pasta_destino
    instalar_dependencias
    iniciar_swarm_master
    adicionar_nos_workers
    criar_servico_docker
}

# Executar o script
main

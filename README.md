# Setup Docker Swarm Cluster com Proxy e MySQL

Este projeto configura um ambiente completo com Docker Swarm, NGINX como proxy reverso e MySQL, utilizando três scripts automatizados para facilitar o processo.

## 🖥️ Sobre o Projeto

A proposta deste projeto é demonstrar a utilização prática de **Docker** e **Docker Swarm** no contexto de microsserviços. Inspirado na história fictícia de **Toshiro Shibakita**, o projeto explora cenários comuns de infraestrutura moderna, como balanceamento de carga, persistência de dados e automação, no ambiente de contêineres.

**Objetivos principais:**
- Criar um cluster Docker Swarm funcional.
- Automatizar a configuração de um banco de dados MySQL customizado.
- Configurar um proxy reverso com NGINX para balanceamento de carga.
- Simplificar o processo de setup com scripts bem definidos.

## 🛠️ Ferramentas Utilizadas

- **Docker** e **Docker Swarm**
- **NGINX** (proxy reverso)
- **MySQL 5.7**
- **PHP 8.2 com Apache**
- **Shell Script** para automação
- **NFS** (para replicação de volume entre nós do cluster)

## 📁 Estrutura do Projeto

```plaintext
.
├── proxy/
│   ├── Dockerfile
│   └── nginx.conf
├── mysql_custom/
│   ├── Dockerfile
│   └── banco.sql
├── setup_docker_swarm_cluster.sh
├── setup_mysql.sh
├── setup_proxy.sh
└── README.md
```

## ⚙️ Scripts e Suas Funcionalidades

### `setup_docker_swarm_cluster.sh`

- Automatiza a criação do cluster Docker Swarm.
- Cria a pasta `/mnt/web` em todos os nós (master e workers).
- Instala dependências (`docker.io`, `nfs-common`).
- Inicializa o Swarm no nó master.
- Adiciona os workers automaticamente ao cluster.
- Cria o serviço `app_php-web` com imagem `php:8.2-apache`, instalando `mysqli` dinamicamente.
- Monta o volume compartilhado com bind (`/mnt/web`).

### `setup_mysql.sh`

- Builda uma imagem customizada `custom-mysql` baseada no `mysql:5.7`.
- Inicializa o banco com o script `bancodedados.sql`.
- Cria o volume `mysql-data` para persistência dos dados.

### `setup_proxy.sh`

- Builda a imagem `proxy-app` baseada no `Dockerfile` e `nginx.conf` da pasta `proxy`.
- Remove o container antigo, se existir.
- Sobe o container `my-proxy-app` na porta 4500.
- Atua como proxy reverso para distribuir requisições entre os containers do serviço PHP.

## 🚀 Como Executar Localmente

> Certifique-se de ter o Docker instalado e as permissões adequadas para executar containers e scripts.

1. **Configurar o banco MySQL**
```bash
./setup_mysql.sh
```

2. **Subir o cluster Docker Swarm**
```bash
./setup_docker_swarm_cluster.sh
```

3. **Rodar o proxy NGINX**
```bash
./setup_proxy.sh
```

Acesse a aplicação em:
```
http://localhost:4500
```

## ✅ Funcionalidades

- Cluster de containers PHP Apache replicados.
- Volume compartilhado via NFS para os arquivos da aplicação.
- Proxy reverso com NGINX para balanceamento de carga.
- Inicialização automática do banco de dados MySQL com script customizado.
- Scripts automatizados para facilitar setup local ou em cloud.

## 🌟 Projeto Base

Este projeto é inspirado na história fictícia de **Toshiro Shibakita**, um dono de supermercados que navega pelos desafios de microsserviços em seu ambiente de trabalho. A ideia central é mostrar como ferramentas modernas como Docker e Docker Swarm podem ser aplicadas para resolver problemas reais de infraestrutura, como:

- Escalabilidade horizontal de aplicações.
- Persistência de dados em um ambiente distribuído.
- Balanceamento de carga para melhorar a performance e disponibilidade.

O nome do projeto também reflete a temática de aprendizado e experimentação em ambientes complexos, trazendo um toque criativo e único à iniciativa.

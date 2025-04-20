

# Cluster Docker Swarm com Proxy Reverso e MySQL Automatizado

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![NGINX](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Shell Script](https://img.shields.io/badge/shell_script-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-%238C8C8C.svg?style=for-the-badge&logo=php&logoColor=white)


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

> 💡 Certifique-se de que:
> - Você tem permissões de sudo.
> - Todos os nós estão acessíveis via SSH.
> - O Docker está instalado em todos eles.


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

Este projeto é inspirado na história fictícia, criada por [Denilson Bonatti](https://github.com/denilsonbonatti), de **Toshiro Shibakita**, um dono de supermercados que navega pelos desafios de microsserviços em seu ambiente de trabalho. A ideia central é mostrar como ferramentas modernas como Docker e Docker Swarm podem ser aplicadas para resolver problemas reais de infraestrutura, como:

- Escalabilidade horizontal de aplicações.
- Persistência de dados em um ambiente distribuído.
- Balanceamento de carga para melhorar a performance e disponibilidade.

O nome do projeto também reflete a temática de aprendizado e experimentação em ambientes complexos, trazendo um toque criativo e único à iniciativa.

## 🧩 Próximos Passos

- Adicionar autenticação no MySQL.
- Criar containers adicionais (ex: Redis, frontend em React).
- Melhorar resiliência com Health Checks e Restart Policies.

## 📬 Contato

Você pode me encontrar nas seguintes plataformas:

[![GitHub](https://img.shields.io/badge/GitHub-%23000000.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/brenda-gouveia)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230A66C2.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/brenda-gomes-gouveia)
[![Email](https://img.shields.io/badge/Email-%23D14836.svg?style=for-the-badge&logo=gmail&logoColor=white)](mailto:brendaggouveia@gmail.com)


## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar PRs com melhorias.

-----

📘 *Aprender infraestrutura não precisa ser complicado. Com o poder dos scripts e containers, você pode criar ambientes robustos e escaláveis em minutos. Explore, modifique e use este projeto como base para seus próprios desafios!*

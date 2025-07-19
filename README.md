# Infraestrutura da Plataforma MeuPet

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

Este repositório contém a configuração e a orquestração de toda a infraestrutura de suporte para a plataforma de microsserviços **MeuPet**. Ele é o responsável por iniciar, conectar e gerenciar os serviços compartilhados essenciais para a operação da aplicação em ambientes de desenvolvimento e produção.

---

## 🚀 Sobre a Infraestrutura

O objetivo deste projeto é fornecer uma base estável e configurável sobre a qual todos os outros microsserviços de negócio (usuários, animais, etc.) e o frontend da aplicação irão operar. Utilizamos o `docker-compose` para orquestrar os seguintes componentes-chave:

* **API Gateway (NGINX):** Atua como o ponto de entrada único para todas as requisições externas (do frontend), gerenciando o roteamento para os microsserviços de backend e aplicando políticas de segurança, como CORS.
* **Banco de Dados Principal (PostgreSQL):** Uma instância de banco de dados relacional que serve como armazenamento persistente para os dados dos microsserviços.

### **Principais Características:**

* **Orquestração Simplificada:** Todos os serviços são iniciados e gerenciados via um único comando `docker-compose`.
* **API Gateway Robusto:** NGINX configurado como um reverse proxy de alta performance, lidando com roteamento e políticas de CORS para comunicação entre origens diferentes.
* **Persistência de Dados:** Uso de volumes para garantir a persistência dos dados do banco de dados entre os ciclos de vida dos containers.
* **Ambiente Consistente:** Garante que o ambiente de execução seja o mesmo em diferentes máquinas de desenvolvimento e produção.

---

## 📋 Pré-requisitos

Para executar a infraestrutura, você precisará ter o Docker e o Docker Compose instalados em sua máquina:

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (inclui Docker Compose)

---

## ▶️ Como Executar

Para iniciar toda a infraestrutura da plataforma MeuPet, siga os passos abaixo:

#### Passo 1: Criar a Rede Compartilhada (Executar Apenas Uma Vez)

É fundamental que todos os containers compartilhem a mesma rede virtual para se comunicarem.

```bash
docker network create meupet-network
````

*Se a rede já existir, este comando informará e não fará nada, o que é seguro.*

#### Passo 2: Clonar este Repositório

```bash
git clone [URL_DO_SEU_REPOSITORIO_DE_INFRA.git]
cd meupet-infra # Ou o nome da pasta do seu repositório de infra
```

#### Passo 3: Iniciar os Containers da Infraestrutura

Use o Docker Compose para construir as imagens (se não existirem localmente) e iniciar todos os containers em segundo plano (`-d`).

```bash
docker-compose up --build -d
```

#### Passo 4: Verificar o Status dos Serviços

Para garantir que todos os componentes da infraestrutura estão rodando e saudáveis, use o comando:

```bash
docker-compose ps
```

Você deve ver os containers `meupet_postgres` e `meupet_nginx_gateway` (ou os nomes dos seus containers) com o status `Up` e `healthy` (se healthchecks forem configurados).

-----

## 🚦 GATEWAY API (NGINX)

O NGINX é o nosso ponto de entrada principal para as requisições do frontend. Ele escuta na porta `8000` e redireciona o tráfego para os microsserviços de backend de acordo com as regras de localização e roteamento definidas no [`nginx.conf`](https://www.google.com/search?q=./nginx/nginx.conf).

### **Porta de Acesso:**

  * **Gateway (HTTP):** `http://localhost:8000`

### **Variáveis de Ambiente para Microsserviços:**

O NGINX utiliza variáveis de ambiente injetadas no container (`PORT`, `USERS_API_URL`, `ANIMALS_API_URL`) para configurar dinamicamente seus `proxy_pass` para os microsserviços. Isso é gerenciado pelo `docker-entrypoint.sh`.

### **Regras de Roteamento:**

  * **Serviço de Usuários:** Requisições para `http://localhost:8000/usuarios/...` são roteadas para o microsserviço de usuários.
      * **Backend:** `https://meupet-users-api-prod-7138bdbc415a.herokuapp.com` (Exemplo de URL real de produção).
  * **Serviço de Animais:** Requisições para `http://localhost:8000/animais/...` são roteadas para o microsserviço de animais.
      * **Backend:** `https://meupet-animals-api-prod-d989fce37073.herokuapp.com` (Exemplo de URL real de produção).

### **Políticas de CORS:**

O NGINX está configurado para adicionar os cabeçalhos de CORS necessários, permitindo que o frontend (hospedado no Vercel) se comunique com os microsserviços através do Gateway.

  * `Access-Control-Allow-Origin`: `*` (Permite qualquer origem para flexibilidade de desenvolvimento. **Em produção, esta deve ser alterada para a URL exata do seu frontend, por exemplo, `https://meupet-frontend-web.vercel.app`**).
  * `Access-Control-Allow-Methods`: `GET, POST, PUT, DELETE, OPTIONS`
  * `Access-Control-Allow-Headers`: `DNT, User-Agent, X-Requested-With, If-Modified-Since, Cache-Control, Content-Type, Range, Authorization`
  * **Preflight Requests:** O NGINX lida com requisições `OPTIONS` (preflight) respondendo com `204 No Content` e os cabeçalhos CORS apropriados para o navegador.

-----

## 🔌 Conexão com Microsserviços de Negócio

Os microsserviços de negócio (como `users-api` e `animals-api`) devem ser iniciados separadamente (geralmente em seus próprios repositórios e `docker-compose.yml` ou executados diretamente) e precisam estar acessíveis na mesma rede Docker (`meupet-network`) para que o NGINX possa rotear o tráfego para eles. O NGINX espera que eles estejam disponíveis nas URLs especificadas em sua configuração (as URLs Heroku dos seus microsserviços).

-----

## ⏹️ Como Parar a Infraestrutura

Para parar todos os containers e a rede iniciados por este `docker-compose.yml`, execute:

```bash
docker-compose down
```

Para parar e remover também os volumes de dados (resetar o banco de dados), use:

```bash
docker-compose down -v
```

-----

## 🤝 Contribuição

Contribuições são bem-vindas\! Sinta-se à vontade para abrir issues ou pull requests.

-----

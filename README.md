# Infraestrutura da Plataforma MeuPet

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kong](https://img.shields.io/badge/Kong-003459?style=for-the-badge&logo=kong&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

Este repositório contém a configuração e a orquestração de toda a infraestrutura de suporte para a plataforma de microsserviços **MeuPet**. Ele é o responsável por iniciar, conectar e gerenciar os serviços compartilhados, como o API Gateway e os bancos de dados.

---

## 🚀 Sobre a Infraestrutura

O objetivo deste projeto é fornecer uma base estável e configurável sobre a qual todos os outros microsserviços da aplicação (usuários, animais, etc.) irão operar. Utilizamos o `docker-compose` para orquestrar os seguintes componentes:

-   **API Gateway (Kong):** Atua como o ponto de entrada único para todas as requisições externas (do frontend), gerenciando o roteamento para os microsserviços corretos.
-   **Banco de Dados Principal (MySQL):** A instância do MySQL que é compartilhada entre os microsserviços de negócio.

---

## 📋 Pré-requisitos

-   [Docker](https://www.docker.com/products/docker-desktop/)
-   [Docker Compose](https://docs.docker.com/compose/install/)

---

## ▶️ Como Executar

Para iniciar toda a infraestrutura da plataforma, siga os passos:

#### Passo 1: Criar a Rede Compartilhada (Executar Apenas Uma Vez)

Antes de iniciar qualquer serviço, você precisa criar a rede virtual que permitirá que todos os containers se comuniquem.

```bash
docker network create meupet-network
```
*Se a rede já existir, este comando informará e não fará nada, o que é seguro.*

#### Passo 2: Clonar e Iniciar a Infraestrutura

1.  **Clone este repositório:**
    ```bash
    git clone [https://github.com/MeuPet-Platform/meupet-infra.git](https://github.com/MeuPet-Platform/meupet-infra.git)
    cd meupet-infra
    ```
2.  **Inicie os containers:**
    Use o Docker Compose para construir as imagens e iniciar os containers em segundo plano (`-d`).
    ```bash
    docker-compose up --build -d
    ```
3.  **Verifique o status:**
    Para garantir que tudo está rodando, use o comando:
    ```bash
    docker-compose ps
    ```
    Você deve ver os containers `meupet_mysql` e `meupet_kong_gateway` com o status `Up`.

---

##  GATEWAY API (Kong)

O Kong é o nosso ponto de entrada. Ele escuta na porta `8000` e redireciona o tráfego de acordo com as regras definidas no arquivo `kong/kong.yaml`.

### Regras de Roteamento Atuais:

-   **Serviço de Usuários:** Qualquer requisição para `http://localhost:8000/usuarios/...` será redirecionada para o serviço `users-api`.
-   **Serviço de Animais:** Qualquer requisição para `http://localhost:8000/animais/...` será redirecionada para o serviço `animals-api`.

### Endpoints Administrativos do Kong

-   **Admin API:** `http://localhost:8001`
-   **Verificar Rotas Carregadas:** `curl http://localhost:8001/routes`

---

## ⏹️ Como Parar a Infraestrutura

Para parar todos os containers iniciados por este arquivo, execute:
```bash
docker-compose down
```
Para parar e remover os volumes de dados (resetar o banco), use:
```bash
docker-compose down -v
```

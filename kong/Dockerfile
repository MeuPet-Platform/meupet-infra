# Começamos com a imagem oficial do Kong
FROM kong:latest

# Copia nosso arquivo de configuração local para dentro da imagem,
# no local padrão que o Kong procura.
# O Docker irá lidar com as permissões corretamente durante o build.
COPY kong.yaml /etc/kong/kong.yaml
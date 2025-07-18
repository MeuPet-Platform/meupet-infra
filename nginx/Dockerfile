FROM nginx:1.25-alpine
# Copia o arquivo de configuração NGINX para o local padrão
COPY nginx.conf /etc/nginx/nginx.conf

# Copia um script para injetar variáveis de ambiente no NGINX conf
# (NGINX não lê variáveis de ambiente diretamente em seu conf, precisa de envsubst)
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Exponha a porta, embora o Heroku use $PORT
EXPOSE 80

# NGINX já tem um CMD padrão que será executado pelo entrypoint
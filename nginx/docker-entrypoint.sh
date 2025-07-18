FROM nginx:1.25-alpine

# Copia o nginx.conf já com as URLs fixas
COPY nginx.conf /etc/nginx/nginx.conf

# Exponha a porta usada no nginx.conf
EXPOSE 80

# Usa o entrypoint padrão do NGINX

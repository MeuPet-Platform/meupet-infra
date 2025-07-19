#!/bin/sh

export PORT
export USERS_API_URL
export ANIMALS_API_URL

# Substitui variáveis no nginx.conf
envsubst '${PORT} ${USERS_API_URL} ${ANIMALS_API_URL}' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp
mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf

# ✅ Exibe o conteúdo final no log do Heroku
echo "===== nginx.conf FINAL gerado ====="
cat /etc/nginx/nginx.conf
echo "==================================="

# Executa o NGINX em foreground
exec nginx -g "daemon off;"

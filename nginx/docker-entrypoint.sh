#!/bin/sh
# Substituir variáveis de ambiente no nginx.conf antes de iniciar
envsubst '$${PORT},$${USERS_API_URL},$${ANIMALS_API_URL}' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp \
&& mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf \
&& exec nginx -g "daemon off;"
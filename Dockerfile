FROM caddy:latest

WORKDIR /usr/share/caddy

COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html index.html

EXPOSE 8080

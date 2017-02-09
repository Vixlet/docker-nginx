FROM  nginx:alpine
WORKDIR  /usr/share/nginx/html
EXPOSE  80
ENV  PRODUCTION_MODE=on
ENV  DEVELOPMENT_MODE=off
ENV  NGINX_HOST=localhost
ENV  NGINX_PORT=80
RUN  mkdir -p /etc/nginx/logs /etc/nginx/sites-enabled /etc/nginx/sites-available \
  && rm -Rf /etc/nginx/nginx.conf \
  && rm -Rf /etc/nginx/conf.d/*
COPY  nginx.conf.template /etc/nginx/
COPY  conf.d/* /etc/nginx/conf.d/
COPY  root/envsubst /root/envsubst
COPY  root/entry /root/entry
COPY  root/test /root/test
RUN  ls /etc/nginx/nginx.conf.template | /root/envsubst \
  && ls /etc/nginx/conf.d/*.conf.template | /root/envsubst
ENTRYPOINT  ["/root/entry"]
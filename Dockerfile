FROM  nginx:alpine
WORKDIR  /usr/share/nginx/html
EXPOSE  80
ENV  PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/bin'
ENV  PRODUCTION_MODE='on'
ENV  NGINX_HOST='localhost'
ENV  NGINX_PORT='80'
RUN  mkdir -p /etc/nginx/logs \
     /etc/nginx/conf.d \
     /etc/nginx/includes.d \
     /etc/nginx/sites-available \
     /etc/nginx/sites-enabled \
  && rm -Rf /etc/nginx/nginx.conf \
  && rm -Rf /etc/nginx/conf.d/* \
  && rm -Rf /etc/nginx/includes.d/* \
  && rm -Rf /etc/nginx/sites-available/* \
  && rm -Rf /etc/nginx/sites-enabled/*
COPY  nginx.conf.template /etc/nginx/
COPY  conf.d/* /etc/nginx/conf.d/
COPY  includes.d/* /etc/nginx/includes.d/
COPY  sites-enabled/* /etc/nginx/sites-enabled/
COPY  bin/envsubst /root/bin/envsubst
COPY  bin/entrypoint /root/bin/entrypoint
COPY  bin/test /root/bin/test
COPY  bin/usedefault /root/bin/usedefault
ENTRYPOINT  ["/root/bin/entrypoint"]
# Source image
FROM  nginx:1.7.9

# Increate system ulimit
COPY  ./limits.conf /etc/security/limits.conf

# Replace Nginx server configuration
RUN  rm /etc/nginx/nginx.conf
COPY  ./nginx.conf /etc/nginx/nginx.conf.tpl

# Clear Nginx site configurations
RUN  rm -Rf /etc/nginx/conf.d/*
RUN  mkdir -p /etc/nginx/sites-enabled /etc/nginx/sites-available

# Copy start-up script
COPY  ./start.sh /start.sh

# Set working directory
WORKDIR  /var/app

# Start nginx
CMD  [ "/start.sh" ]

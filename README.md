# `vixlet/nginx:alpine`

Customized version of the [`nginx:alpine`](https://github.com/docker-library/docs/tree/master/nginx) docker image with some sugar for passing environment variables to simplify the process of configuring Nginx.

## Usage

### Straight up
```sh
# host a local directory 'dist/' by mounting at '/usr/share/nginx/html'
docker run -P -v ./dist:/usr/share/nginx/html vixlet/nginx:alpine

# develop locally by setting PRODUCTION_MODE=off
docker run -P -v ./dist:/usr/share/nginx/html -e 'PRODUCTION_MODE=off' vixlet/nginx:alpine

# use customize server *.conf by mounting at '/etc/nginx/conf.d'
docker run -P -v ./conf.d:/etc/nginx/conf.d -v ./dist:/usr/share/nginx/html vixlet/nginx:alpine
```

### Basic
```dockerfile
FROM  vixlet/nginx:alpine
COPY  dist /usr/share/nginx/html
```

### Less basic
```dockerfile
FROM  vixlet/nginx:alpine
ENV  NGINX_HOST=example.com
COPY  dist /usr/share/nginx/html
```

### Much less basic
```dockerfile
FROM  vixlet/nginx:alpine
RUN  rm /etc/nginx/conf.d/*.conf.template
COPY  site.conf /etc/nginx/conf.d/
COPY  dist /usr/share/nginx/html
```

### "Gee zip" edition
```dockerfile
FROM  vixlet/nginx:alpine
RUN  rm /etc/nginx/conf.d/*.conf.template \
  && mv /etc/nginx/conf.d/gzip.conf.default /etc/nginx/conf.d/gzip.conf
COPY  site.conf /etc/nginx/conf.d/
COPY  dist /usr/share/nginx/html
```

### "Series of tubes" edition
```dockerfile
FROM  vixlet/nginx:alpine
RUN  rm /etc/nginx/conf.d/*.conf.template \
  && mv /etc/nginx/conf.d/gzip.conf.default /etc/nginx/conf.d/gzip.conf \
  && mv /etc/nginx/conf.d/proxy.conf.default /etc/nginx/conf.d/proxy.conf
COPY  site.conf /etc/nginx/conf.d/
COPY  dist /usr/share/nginx/html
```

### "Kitchen sink" edition
```dockerfile
FROM  vixlet/nginx:alpine
RUN  rm /etc/nginx/conf.d/*.conf.template \
  && mv /etc/nginx/conf.d/gzip.conf.default /etc/nginx/conf.d/gzip.conf \
  && mv /etc/nginx/conf.d/proxy.conf.default /etc/nginx/conf.d/proxy.conf \
  && mv /etc/nginx/conf.d/cors.conf.default /etc/nginx/conf.d/cors.conf \
  && mv /etc/nginx/includes.d/cors.conf.default /etc/nginx/includes.d/cors.conf
ENV  ENV_SUBSTITUTE='$MY_VAR_1:$MY_VAR_2'
COPY  site.conf /etc/nginx/sites-enabled/site.conf.template
COPY  dist /usr/share/nginx/html
```

## Environment variables
| Name | Values | Description |
| ---- | ------ | ----------- |
| `PRODUCTION_MODE` | `on` (default), `off` | Set to `off` when using volume-mounted directories to prevent modified files from getting mangled by **sendfile**! |
| `NGINX_HOST` | `localhost` (default) | Hostname used by the default server in `/etc/nginx/conf.d/default.conf` |
| `NGINX_PORT` | `80` (default) | Port used by the default server in `/etc/nginx/conf.d/default.conf` |
| `ENV_SUBSTITUTE` | `<empty>` (default) | Colon-delimited list of variables to replace in `*.conf.template` files *(the supported variables `$PRODUCTION_MODE:$DEVELOPMENT_MODE:$NGINX_HOST:$NGINX_PORT` are always included)* |
| `DEVELOPMENT_MODE` | (automatic)<sup>†</sup> | *Set automatically to opposite of `PRODUCTION_MODE`* |

## License
ISC © 2014, 2015, 2016, 2017 [Vixlet CA LLC](http://www.vixlet.com/)

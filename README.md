# Nginx Docker Image

Serve content with a highly customizable Nginx server; designed for use with AWS ElasticBeanstalk! :P


## Table of Contents
- [Overview](#overview)
- [Base Docker Image](#basedockerimage)
- [Usage](#usage)
    + [Running the container](#runningthecontainer)
    + [Configuring Nginx](#configuringnginx)
    + [Setting a script hook](#settingascripthook)
    + [Supported environment variables](#supportedenvironmentvariables)
- [License](#license)


## Overview
This is a minimal Docker image for running Nginx in a highly customizable manner, by making use of a bash script with hooks as the container's run command. It's meant primarily as a workaround for AWS ElasticBeanstalk's lack of a way to specify a `run` command for a Docker container, and is designed for all hosted content and configuration files to be provided via mounted directories.


## Base Docker Image
- [nginx:1.9.2](https://registry.hub.docker.com/_/nginx/)
    + [Nginx Official Dockerfile](https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile)


## Usage
1. If you haven't already, install [Docker](https://www.docker.com/)
2. Pull the [latest automated build](https://registry.hub.docker.com/u/vixlet/nginx/) from [DockerHub](https://registry.hub.docker.com/u/): `docker pull vixlet/nginx:latest`
3. Run the container!

### Running the container
```sh
### RUN CONTAINER INTERACTIVELY
docker run -it --rm \
    -p 80:80 \
    -v $( pwd ):/var/app \
    -v $( pwd )/conf.d:/etc/nginx/conf.d \
    --name "vixlet-nginx-example" \
    vixlet/nginx:latest

### RUN CONTAINER IN THE BACKGROUND
docker run -d \
    -p 80:80 \
    -v $( pwd ):/var/app \
    -v $( pwd )/conf.d:/etc/nginx/conf.d \
    --name "vixlet-nginx-example" \
    vixlet/nginx:latest

### RUN CONTAINER IN THE BACKGROUND FOR LOCAL DEVELOPMENT
docker run -d \
    -p 80:80 \
    -v $( pwd ):/var/app \
    -v $( pwd )/conf.d:/etc/nginx/conf.d \
    -e "DOCKER_WATCH=on" \
    --name "vixlet-nginx-example" \
    vixlet/nginx:latest
```

### Configuring Nginx
Mount a directory containing your Nginx site configuration files to either `/etc/nginx/conf.d` or `/etc/nginx/sites-enabled`.

Nginx loads the configuration files in the following order:
- `/etc/nginx/conf.d/*.conf`
- `/etc/nginx/sites-enabled/*.conf`

### Setting a script hook
A custom pre-start script can be provided to handle any pre-start tasks (such as rewriting Nginx configuration files with environment variable values, which can only be done at run-time).

> Note that any pre-start script must not start any other persistent processes or invoke Nginx itself!

To use a custom pre-start script, simply provide an executable file in your working directory named `docker-prestart.sh` (or set the `DOCKER_PRESTART_SCRIPT` environment variable to the filepath of the desired script) and the Docker container will automatically invoke it immediately prior to starting the Nginx process.

### Supported environment variables
| Variable Name | Example Values | Description |
| ------------- | -------------- | ----------- |
| **`DOCKER_PRESTART_SCRIPT`** | `"/var/app/docker-prestart.sh"` (default) | Path to script to run immediately before Nginx |
| **`DOCKER_WATCH`** | `""` (default) or `"on"` | Enable when other processes can change files hosted by Nginx (such as `gulp watch`); disables `sendfile`, `tcp_nopush`, and `tcp_nodelay` directives |


## License
ISC © 2014, 2015 [Vixlet CA LLC](http://www.vixlet.com/)

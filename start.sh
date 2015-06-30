#!/bin/bash


# Replace the server configuration with the template
cp -rf /etc/nginx/nginx.conf.tpl /etc/nginx/nginx.conf


# Support watch processes that dynamically change hosted files
if [ -n "${DOCKER_WATCH}" ]; then
  # Watch is enabled, so files are dynamic
  test $? && sed -i 's/__OFF_WHEN_DYNAMIC__/off/g' /etc/nginx/nginx.conf
else
  # Watch is disabled, so files are static
  test $? && sed -i 's/__OFF_WHEN_DYNAMIC__/on/g' /etc/nginx/nginx.conf
fi


# Set default value for pre-start script environment variable
if [ -z "${DOCKER_PRESTART_SCRIPT}" ]; then
  DOCKER_PRESTART_SCRIPT="/var/app/docker-prestart.sh"
fi


# Run user-specified pre-start script, if it exists
if [ -x ${DOCKER_PRESTART_SCRIPT} ]; then
  test $? && echo "Running docker prestart script..." \
     && ${DOCKER_PRESTART_SCRIPT}
fi

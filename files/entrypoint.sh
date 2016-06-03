#!/bin/bash -x
set -euo pipefail
IFS=$'\n\t'

# Initialize empty host volumes
if [ -z "$(ls -A "${APPDIR}/userdata")" ]; then
  # Copy userdata dir
  echo "No userdata found... initializing."
  cp -av "${APPDIR}/userdata.dist/." "${APPDIR}/userdata/"
fi

if [ -z "$(ls -A "${APPDIR}/conf")" ]; then
  # Copy userdata dir
  echo "No configuration found... initializing."
  cp -av "${APPDIR}/conf.dist/." "${APPDIR}/conf/"
fi

# Prettier interface
if [ -n "$START_COMMAND" ]; then
  eval "$START_COMMAND"
elif [ "$1" = 'debug' ] || [ -n "$DEBUG_PARAMETERS" ]; then
  eval "echo 'log:tail' | ${APPDIR}/start_debug.sh $DEBUG_PARAMETERS"
elif [ "$1" = 'server' ] || [ "$1" = 'openhab' ]; then
  eval "${APPDIR}/start.sh"
elif [ "$1" = 'console' ] || [ "$1" = 'shell' ]; then
  exec "${APPDIR}/runtime/karaf/bin/client"
else
  exec "$@"
fi


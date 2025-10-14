#!/usr/bin/env bash

ACTION="${1}"

if [[ -z "${ACTION}" ]]; then
  echo "Restart or stop the static php-fpm server."
  echo -e "Usage:"
  echo -e "    $(basename ${0}) [restart|stop]"
  exit
fi

PID=$(pgrep -f "php-fpm: master process" | tail -n1)
if [[ -n "${PID}" ]]; then
  if [[ "${ACTION}" == restart ]]; then
    kill -SIGUSR2 "${PID}"
    echo "Static PHP-FPM PID is: ${PID}"
  fi

  if [[ "${ACTION}" == stop ]]; then
    echo "Static PHP-FPM PID was: ${PID}"
    kill -term "${PID}"
  fi
else
  echo "Static PHP-FPM service is not running!"
fi

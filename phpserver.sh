#!/usr/bin/env bash

port=9100

while true; do
  if ! nc -z localhost "${port}"; then
    break
  fi
  ((port++))
done

php -S 0.0.0.0:${port}

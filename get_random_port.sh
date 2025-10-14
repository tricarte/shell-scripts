#!/usr/bin/env bash

start=8080

while true; do
  if ! nc -z localhost "${start}"; then
    echo -n "${start}"
    break
  fi
  ((start++))
done

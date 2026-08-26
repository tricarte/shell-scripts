#!/usr/bin/env bash

if command -v notify-send >/dev/null 2>&1; then
  NOTIFYBIN=$(command -v notify-send)
fi

life=$(sudo hdsentinel -dev /dev/sda -solid | cut -d' ' -f3)
str="Disk health: ${life}%"

if [ -t 0 ]; then
  # We are in interactive shell
  echo "${str}"
else
  # We are not in interactive shell
  $NOTIFYBIN -a HDSentinel "${str}"
fi

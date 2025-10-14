#!/usr/bin/env bash

FD=$(command -v fd)

if [[ -z "$FD" ]]; then
  echo "fd could not be found"
  exit 1
fi

# $FD --base-directory "${@:-./}" --exact-depth 1 \
$FD --search-path "${@:-./}" --exact-depth 1 \
  --type f -a \
  --color never --exec-batch ls -t -1 | head -n1

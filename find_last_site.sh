#!/usr/bin/env bash

FD=$(command -v fd)
if [[ $FD ]]; then
  SITE=$(
    $FD wpstarter.json --exact-depth 2 \
      --type f -a --base-directory "${HOME}/sites" \
      --color never --exec-batch ls -t -Q -1 | head -n1 |
      xargs dirname | xargs basename
  )
else
  SITE=$(
    find "${HOME}/sites"/ \
      -maxdepth 2 \
      -type f \
      -name wpstarter.json \
      -printf "%CY-%Cm-%Cd %CT %h\n" |
      sort -r | head -n1 | xargs basename
  )
fi

printf '%s' "$SITE"

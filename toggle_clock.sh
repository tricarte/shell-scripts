#!/usr/bin/env bash

output=$(kitty @ --to unix:/tmp/mykitty ls | jq '.[].tabs[].windows[] | select(.title=="myttyclock")')

if [[ -z $output ]]; then
  kitty @ --to unix:/tmp/mykitty launch --type=overlay-main \
    --title=myttyclock tty-clock -scrbC 3
else
  kitty @ --to unix:/tmp/mykitty close-window -m title:myttyclock
fi

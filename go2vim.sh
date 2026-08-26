#!/usr/bin/env bash

kitty=$(command -v kitty)

if [[ -n $kitty ]]; then
  vim=$(kitty @ --to unix:/tmp/mykitty ls | jq '.[].tabs[0].windows[0].title')
  # This both matches vim and nvim
  if [[ $vim =~ vim ]]; then
    kitty @ --to unix:/tmp/mykitty focus-window --match id:1 --no-response
  fi
fi

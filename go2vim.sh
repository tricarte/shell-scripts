#!/usr/bin/env bash

kitty=$(command -v kitty)
# if [[ -n $kitty ]]; then
#   # isActiveWindow=$(kitty @ --to unix:/tmp/mykitty ls | jq '.[].tabs[].windows[0].is_active_window')
#   isActiveWindow=$(kitty @ --to unix:/tmp/mykitty ls | jq '.[].tabs[0].windows[0].is_active')
#
#   if [[ $isActiveWindow == "false" ]]; then
#     vim=$(kitty @ --to unix:/tmp/mykitty ls | jq '.[].tabs[0].windows[0].foreground_processes[0].cmdline[0]')
#     if [[ $vim =~ vim ]]; then
#       kitty @ --to unix:/tmp/mykitty focus-window --match id:1 --no-response
#     fi
#   fi
# fi

if [[ -n $kitty ]]; then
  vim=$(kitty @ --to unix:/tmp/mykitty ls | jq '.[].tabs[0].windows[0].foreground_processes[0].cmdline[0]')
  if [[ $vim =~ vim ]]; then
    kitty @ --to unix:/tmp/mykitty focus-window --match id:1 --no-response
  fi
fi

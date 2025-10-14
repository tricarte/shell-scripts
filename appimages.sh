#!/usr/bin/env bash

for item in fd rofi; do
  if ! command -v "${item}" >/dev/null 2>&1; then
    echo "${item} is not installed!"
    exit 1
  fi
done

sel=$(fd --base-directory "$HOME/appimages" --exec basename {} | rofi -dmenu -i -p 'Select appimage')
# sel=$( fd --base-directory "$HOME/Downloads/appimages" --exec basename {} | fzf)
if [[ -n "$sel" ]]; then
  cd "$HOME/appimages" && ./"${sel}" || exit
fi

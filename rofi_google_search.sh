#!/usr/bin/env bash
set -e
echo "" | rofi -dmenu -p "Search:" | xargs -I{} xdg-open https://www.google.com.tr/search?q={}

#!/usr/bin/env bash
set -e

xdotool search --desktop 0 --name "Firefox" windowactivate
# xdotool key Alt+1
xdotool key F5
# xdotool key Return
WID=$(xdotool search --onlyvisible --class konsole | head -1)
# WID=$(xdotool search --onlyvisible --class terminator|head -1)
xdotool windowactivate "${WID}"

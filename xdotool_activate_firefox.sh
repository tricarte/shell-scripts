#!/usr/bin/env bash
set -e

# eval $(xdotool getmouselocation --shell)
xdotool search --desktop 0 --name "Firefox" windowactivate
xdotool key super 5
# xdotool click 1
# xdotool mousemove "$X" "$Y"

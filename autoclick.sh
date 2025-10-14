#!/usr/bin/env bash

sleep 3

# Coordinates of the screen area where you want to generate clicks (adjust as needed)
X_COORD=683
Y_COORD=384

# Delay between clicks in milliseconds (100ms = 0.1 seconds)
CLICK_DELAY=100

# Number of clicks to generate (-1 for infinite loop)
CLICK_COUNT=-1

# Loop to generate clicks
# while [ $CLICK_COUNT -ne 0 ]; do
#     # Generate a click at the specified coordinates
#     xdotool mousemove --sync $X_COORD $Y_COORD click 1
#
#     # Sleep for the specified delay
#     sleep 0.1
#
#     # Decrement click count (-1 means infinite loop)
#     if [ $CLICK_COUNT -ne -1 ]; then
#         CLICK_COUNT=$((CLICK_COUNT - 1))
#     fi
# done

while true; do
  # xdotool mousemove --sync $X_COORD $Y_COORD click 1
  xdotool click --delay 10 --repeat 6 1

  # Sleep for the specified delay
  sleep 0.3
done

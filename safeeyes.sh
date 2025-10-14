#!/usr/bin/env bash

# A simple shell script to tell how much time till the next SafeEyes break
# is left.

NOTIFYBIN=$(command -v notify-send)

min=$(date +%-M)

se=$(safeeyes --status)
if [[ $se =~ ^Next ]]; then
  se=$(safeeyes --status | cut -d':' -f2)
else
  se=0
fi

currdate=$(date "+%Y-%m-%d %H:%M")
# currtime=$(date +%H:%M)

if [[ ! $se == 0 ]]; then
  if [[ $se =~ ^0 ]]; then
    se=${se:1:1}
  fi

  if [[ $se -lt $min ]]; then
    diff=$((60 - min))
    result=$((se + diff))
  else
    result=$((se - min))
  fi
else
  result="none"
fi

if [[ ! $result == "none" ]]; then
  if [[ $result == 0 ]] || [[ $result == 1 ]]; then
    message="About to break - Current date: ${currdate}"
  else
    message="${result} minutes left - Current date: ${currdate}"
  fi
else
  message="Current date: ${currdate}"
fi

if [[ -t 0 ]]; then
  echo "${message}"
else
  if [[ -n $NOTIFYBIN ]]; then
    $NOTIFYBIN -a SafeEyes "${message}"
  fi
fi

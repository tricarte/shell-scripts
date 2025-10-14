#!/usr/bin/env bash
vids=$(fd mp4)

for vid in $vids; do
  size=$(mediainfo --Inform="Video;%Width%X%Height%" "${vid}")
  if [[ $size == '226X400' ]]; then
    echo "${vid}"
  fi
done

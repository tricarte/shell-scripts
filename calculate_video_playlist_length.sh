#!/usr/bin/env bash
files=$(fd --exclude cpvf mp4)
totalLength=0

for item in $files; do
  duration=$(mediainfo --Inform="Video;%Duration%" "${item}")
  totalLength=$((totalLength + duration))
done

echo $totalLength

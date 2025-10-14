#!/usr/bin/env bash

clear
echo "Cropped videos will be placed in 'cropped' directory in current working directory!"

FILES=()
if [[ -z "${*}" ]]; then
  while IFS= read -r line; do
    [[ $line ]] || break
    FILES+=("$line")
  done
else
  FILES=("$@")
fi

for file in "${FILES[@]}"; do
  crop=$(ffmpeg -i "${file}" -t 1 -vf cropdetect -f null - 2>&1 | awk '/crop/ { print $NF }' | tail -1)
  echo "Processing: ${file}..."
  if [[ "${crop}" == *:0:0 ]]; then
    echo  "${file}: No need to crop, skipping!"
    continue
  fi
  if [[ ! -d "${PWD}/cropped" ]]; then
      mkdir "${PWD}/cropped"
  fi
  ffmpeg -loglevel panic -hide_banner -i "${file}" -vf "${crop}" -y "${PWD}/cropped/$(basename "${file}")"
done

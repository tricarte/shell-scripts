#!/usr/bin/env bash

# Downloads items to current directory

file=$1

if [[ -z "${file}" ]]; then
  file="${HOME}/es.txt"
fi

reg='|'
count=0
size_bytes=0
max_bytes=4500000000 # 4.5G
# max_bytes=1000000000 # 1 GB
# max_bytes=150000000 # 150 MB
# max_bytes=285000000 # 285 MB

printf '%s\n' "Your quota is: ${max_bytes}"
read -p "Proceed to download?  (y/n): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  printf "Download aborted."
  exit
fi

if [[ -f "${file}" ]]; then
  while IFS=$'\n' read -r item; do
    if [[ ! $item == *"$reg"* ]] || [[ $item =~ --- ]]; then
      break
    fi

    source=$(printf '%s' "${item}" | cut -d'|' -f1)
    download=$(printf '%s' "${item}" | cut -d'|' -f2)
    filename=${source##*/}

    # Check if we already downloaded the file
    if [[ -f "./${filename}.mp4" ]]; then
      echo "Skipping: ${filename}.mp4 already downloaded."
      continue
    fi

    echo "Checking: ${download}"
    new_size=$(wget -S --spider --timeout=3 "${download}" --start-pos=500M 2>&1 | grep Content-Range | cut -d'/' -f2)

    if [[ $max_bytes -lt $new_size ]]; then
      continue
    fi

    size_bytes=$((new_size + size_bytes))

    if [[ $max_bytes -lt $size_bytes ]]; then
      echo "Total bytes: $size_bytes"
      echo "Downloaded so far: $count"
      echo "Quitting due to quota!!!"
      break
    fi

    echo "Downloading: ${download}"
    wget -O "./${filename}.mp4" "${download}"

    if [[ -f "./${filename}.mp4" ]]; then
      count=$((count + 1))
      echo "${size_bytes}"
    fi

  done < <(cat "${file}")
else
  echo "List does not exist."
fi

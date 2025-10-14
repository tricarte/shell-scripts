#!/data/data/com.termux/files/usr/bin/bash

function download() {
  item="${1}"
  random="${RANDOM}"

  # --silent makes it completely silent so we should add progress meter
  curl "${item}" --silent --progress-meter \
    -x socks5h://localhost:1080 \
    --user-agent 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/120.0' \
    --output "${HOME}/storage/downloads/${random}.mp4"
}

counter=1
while IFS=$'\n' read -r link; do
  echo "Downloading link number: ${counter}."
  download "${link}"
  counter=$((counter + 1))
done < <(cat "${HOME}/storage/downloads/links.txt")

#!/usr/bin/env bash
# TODO: Handle new files

if [[ ! -f "${HOME}/.mp4" ]]; then
  printf '%s' "index=0" >"${HOME}/.mp4"
fi

# shellcheck source=/dev/null
source "${HOME}/.mp4"
combined=""

if [[ ! -f "${HOME}/.mp4_list.gpg" ]] || [[ "${index}" == 0 ]]; then
  nonhc=$(fd mp4 /media --exclude '*cc_*' | shuf)
  hc=$(fd ^cc_ /media | shuf)
  counthc=$(echo "$hc" | wc -l)
  counter=0
  while read -r; do
    combined+="${REPLY}\n" # $REPLY is the current line from $nonhc
    ((counter++))
    if [[ $counter -gt $counthc ]]; then
      hc=$(echo "$hc" | shuf)
      counter=1
    fi
    if [[ $((counter % 2)) -eq 0 ]]; then
      combined+="$(echo "${hc}" | sed -n "${counter}"p)\n"
    fi
  done < <(echo "${nonhc}")
  # gpg --yes --pinentry-mode loopback \
  gpg --yes \
    --output "${HOME}/.mp4_list.gpg" \
    --symmetric < <(echo -e "${combined}" | sed -e '/^$/d')
fi

# list=$(gpg --pinentry-mode loopback -qd "${HOME}/.mp4_list.gpg")
list=$(gpg -qd "${HOME}/.mp4_list.gpg")
count=$(echo "${list}" | wc -l)

if [[ $index -ge $count ]]; then
  index=0
fi

if [[ -n "${list}" ]]; then
  mpv_output=$(mpv --quiet --fullscreen --loop-playlist=no --playlist=- --playlist-start="${index}" < <(echo "${list}"))
  first=$(printf '%s' "${list}" | head -n1)
  if [[ -f "${first}" ]]; then
    last_index=$(printf '%s' "${mpv_output}" | grep -E ^Playing: | cut -d' ' -f2 | wc -l)
    if [[ "${last_index}" != 0 ]]; then
      printf '%s' "index=$((last_index + index < count ? last_index + index - 1 : 0))" >"${HOME}/.mp4"
    fi
  else
    echo "Checking the first file for existence failed. Maybe not mounted yet?"
    exit 1
  fi
else
  echo "${HOME}/.mp4_list.gpg is empty."
  exit 1
fi

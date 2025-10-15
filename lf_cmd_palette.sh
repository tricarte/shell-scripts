#!/usr/bin/env bash

# FZF=$(command -v fzf)
# cmds=$(grep -E ^cmd "${HOME}/.config/lf/lfrc" | cut -d' ' -f2)
# infos=$(grep -E '^# Info:' "${HOME}/.config/lf/lfrc" | cut -d' ' -f3-)
# # c1=$(printf "$cmds" | wc -l)
# # c2=$(printf "$infos" | wc -l)
# paste -d':' <(printf "${cmds}") <(printf "${infos}") | column -t -s':'

FZF=$(command -v fzf)

if [[ -f "/tmp/lf_cmd_palette_cache" ]] && [[ "/tmp/lf_cmd_palette_cache" -ot "${HOME}/.config/lf/lfrc" ]]; then
  rm "/tmp/lf_cmd_palette_cache"
fi

if [[ -f /tmp/lf_cmd_palette_cache ]]; then
  action=$(cat /tmp/lf_cmd_palette_cache | $FZF)
else
  cmds=$(grep -E ^cmd "${HOME}/.config/lf/lfrc" | cut -d' ' -f2)
  infos=$(grep -E '^# Info:' "${HOME}/.config/lf/lfrc" | cut -d' ' -f3-)
  noops=$(echo "$infos" | grep "Noop" | cut -d'>' -f2)
  infos=$(echo "$infos" | grep -v "Noop")
  # TODO: Improve this ugliness
  cmds=$(
    while IFS=$'\n' read item; do
      echo "$cmds" | grep -v "${item}"
    done < <(printf "${noops}\n")
  )
  c1=$(printf "$cmds" | wc -l)
  c2=$(printf "$infos" | wc -l)
  if [[ $c1 == $c2 ]]; then
    action=$(paste -d':' <(printf "${cmds}") <(printf "${infos}") | column -t -s':' | sort | tee /tmp/lf_cmd_palette_cache | $FZF)
    printf "${action}"
  else
    printf "Error: Info strings do not match the count of cmds."
  fi
fi

#!/usr/bin/env bash

# Used in lf
function inBackupProfile() {
  current=$(realpath "${1}")
  while [[ $current != "/" ]]; do
    out=$(grep \""${current}"\" ~/.config/rustic/*.toml)
    if [[ -n "${out}" ]]; then
      printf '%s' "${out}" | head -n1 | cut -d':' -f1
      return
    else
      current=$(dirname "${current}")
    fi
  done
  return 1
}

inBackupProfile "${1}" || printf '%s' "No backup profile contains this item."

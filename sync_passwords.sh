#!/usr/bin/env bash

SOURCE="${HOME}/redmi-sshfs/storage/shared/password_store_2021-07-03T22_00_55.221/password_store_2021-07-03T22_00_55.221"

if [[ ! -d "${SOURCE}" ]]; then
  printf "ERROR: ${SOURCE} not reachable!\n" >&2
  printf "redmifs first?\n" >&2
  exit 1
fi

if which rclone >/dev/null 2>&1; then
  # Sync from redmi to laptop
  rclone -q sync "${SOURCE}" "${HOME}/.password-store"
else
  printf "ERROR: rclone not found!\n" >&2
  exit 1
fi

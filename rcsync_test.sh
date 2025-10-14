#!/usr/bin/env bash

# Try to sync to rustic profiles on different repositories using rclone or rsync

mapfile -t SRC < <(rustic --log-level OFF -P quick snapshots --json | jq -r '.[][1][0].id')
mapfile -t TARGET < <(rustic --log-level OFF -r "/media/${USER}/sandisk32/rustic-backups/quick-notes" snapshots --json | jq -r '.[][1][0].id')

if [[ "${SRC[@]}" == "${TARGET[@]}" ]]; then
  echo "yes it works"
else
  echo "go hack yourself"
fi

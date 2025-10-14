#!/usr/bin/env bash

rclone sync "${HOME}"/repos/sniploc-bulma-carton/src/db \
  gdrive-remote:/toshiba-kubuntu-linux-backup/sniploc-snippets

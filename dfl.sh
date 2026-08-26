#!/usr/bin/env bash

# List dotfiles

cd / || exit && /usr/bin/git \
  --git-dir="${HOME}"/.dotfiles/ \
  --work-tree="${HOME}" ls-files ~ |
  sed "s|^|~/|"

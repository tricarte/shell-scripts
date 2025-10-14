#!/usr/bin/env bash

cd / || exit && /usr/bin/git \
  --git-dir="${HOME}"/.dotfiles/ \
  --work-tree="${HOME}" ls-files ~ |
  sed "s|^|~/|"
  # xargs -I'{}' realpath '{}' | replace "${HOME}" '~'

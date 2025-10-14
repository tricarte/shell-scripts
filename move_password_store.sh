#!/usr/bin/env bash

src="${HOME}/Downloads/kdeconnect"
dest="${HOME}/passwords"

cwd=$(pwd)

archive=$(find "$src" -maxdepth 1 -type f -name 'password_store_*' -exec basename {} \;)

if [[ ! -f "${src}/${archive}" ]]; then
  echo "No password archive in ${src}."
  exit
fi

# First zip and remove the current password directory
current=$(find "$dest" -maxdepth 1 -type d -name 'password_store_*' -exec basename {} \;)
if [[ -d "${dest}/${current}" ]]; then
  cd "${dest}" || exit
  apack -q "${dest}/${current}"_bak.zip "${current}"
  rm -rf "${current:?}"
fi

cd "${cwd}" || exit

# Unzip uploaded archive, extract and move to passwords dir and finally delete it
if [[ -n "${archive}" ]]; then
  cd "${src}" || exit
  aunpack -q "${archive}"
  rm -f "${archive}"

  new=$(find ./ -maxdepth 1 -type d -name 'password_store_*' -exec basename {} \;)
  mv "${new}" "${dest}"
fi

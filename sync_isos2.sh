#!/usr/bin/env bash

if [[ ! -d "/media/${USER}/D892E34792E32928" ]]; then
  printf "External storage is not attached!\n"
  exit 1
fi

source="${1}"

if [[ ! -f "${source}" ]]; then
  printf "Source file does not exist!\n"
  exit 1
fi

source_basename="$(basename "${source}")"
target="/media/${USER}/D892E34792E32928/Documents and Settings/${USER}/Documents/ubuntu_custom_dvd/${source_basename}"

if [[ ! -f "${target}" ]]; then
  printf "Target container iso does not exist!\n"
  exit 1
fi

printf "Unmounting existing containers first\n"
sudo conta --text --non-interactive -d

# Mount pairs
# pass=$(gpg -q -d --pinentry-mode loopback /etc/.container.gpg)
pass=$(gpg -q -d /etc/.container.gpg)
slot=$(echo "${source_basename%%.*}" | cut -d'_' -f2)

printf "Mounting container pairs for %s\n" "${source}"
sudo conta --text --fs-options=umask=022 --non-interactive --mount --slot="${slot}" --password="${pass}" "${source}"
sudo conta --text --fs-options=umask=022 --non-interactive --mount --slot="$((slot + 1))" --password="${pass}" "${target}"

if [[ -d "/media/veracrypt${slot}" ]] && [[ -d "/media/veracrypt$((slot + 1))" ]]; then
  rclone -q sync "/media/veracrypt${slot}" "/media/veracrypt$((slot + 1))" && printf "Done\n"
else
  printf "Source/target directory is not reachable!\n"
fi

sync && sudo conta --text --non-interactive -d
exit

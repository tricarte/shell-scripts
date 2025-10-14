#!/usr/bin/env bash

# Sync contents of isos to backup.iso in external disk.

storages=$(find /media/"${USER}"/* -maxdepth 0 -type d 2>/dev/null)

if [[ -z ${storages} ]]; then
  printf "No external storage attached to the system!\n"
  exit 1
fi

storage=$(printf '%s' "${storages}" | fzf)

if [[ ! -f "${storage}/backup.iso" ]]; then
  printf "External storage does not contain backup.iso!\n"
  exit 1
fi

# pass=$(gpg -q -d --pinentry-mode loopback /etc/.container.gpg)
pass=$(gpg -q -d /etc/.container.gpg)
sudo conta --text --non-interactive \
  --mount --password="${pass}" "${storage}/backup.iso" 2>/dev/null

output=$(conta --text --non-interactive --volume-properties "${storage}/backup.iso" 2>/dev/null)
usb_mpoint=$(printf '%s' "${output}" | grep "Mount Directory" | cut -d' ' -f3)

for item in "${HOME}"/isos/ubuntu_custom_dvd/*.iso; do
  output=$(conta --text --non-interactive --volume-properties "${item}" 2>/dev/null)
  mpoint=$(printf '%s' "${output}" | grep "Mount Directory" | cut -d' ' -f3)
  dirname=$(basename "${item}" .iso)
  if [[ -d "${mpoint}" ]] && [[ -d "${usb_mpoint}/${dirname}" ]]; then
    printf "Syncing: %s -> %s\n" "${mpoint}" "${usb_mpoint}/${dirname}"
    # rclone -q sync --ignore-existing "${mpoint}" "${usb_mpoint}/${dirname}"
    rclone -q sync "${mpoint}" "${usb_mpoint}/${dirname}"
  else
    printf "Target:%s does not have a connected source!\n" "${usb_mpoint}/${dirname}"
  fi
done

printf "Sync done!\n"

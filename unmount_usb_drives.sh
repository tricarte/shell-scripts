#!/bin/bash
# Unmount and power off any user mounted drives.
# https://bbs.archlinux.org/viewtopic.php?id=252759
# In KDE, put this script (or symlink) to ~/.config/plasma-workspace/shutdown

user=$(getent passwd 1000 | cut -d':' -f1)

# array of partitions to be unmounted
mapfile -t ArrayUnmount < <(mount | grep "on /media/${user}/" | cut -c 1-9)

# array of disks to be powered off
mapfile -t ArrayPoweroff < <(mount | grep "on /media/${user}/" | cut -c 1-8)

if [ ${#ArrayUnmount[@]} -gt 0 ]
then
  echo "Writing files/cache to disks"
  sync

  for i in "${ArrayUnmount[@]}"; do
    echo "Unmounting USB disks"
    udisksctl unmount -b "$i"
  done

  for i in "${ArrayPoweroff[@]}"; do
    echo "Powering off USB disks"
    udisksctl power-off -b "$i"
  done
fi

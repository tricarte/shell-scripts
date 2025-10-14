#!/usr/bin/env bash

if [[ ! -x "/usr/local/bin/conta" ]]; then
  echo "conta symlink does not exist in /usr/local/bin"
  exit 1
fi

if [[ -d "${HOME}/isos/ubuntu_custom_dvd" ]]; then
    # res=$(find ./ -maxdepth 1 -type f -name '*.iso')
    res=$(find "${HOME}/isos/ubuntu_custom_dvd/" -maxdepth 1 -type f -name '*.iso')
    if [[ -z $res ]]; then
        echo "No containers found in directory ~/isos/ubuntu_custom_dvd"
        exit 1
    fi
fi

if [[ -f /etc/.container.gpg ]]; then
  pass=$(gpg -qd /etc/.container.gpg)
elif [[ -f "${HOME}/.container" ]]; then
  pass=$(cat "${HOME}/.container")
else
  read -rsp "You have to enter the container password: " pass
fi

if [[ -z $pass ]]; then
  echo "Password cannot be empty."
  exit 1
fi

# First unmount any mounted container
sudo conta --text --non-interactive -d

cd "${HOME}/isos/ubuntu_custom_dvd" || exit
for file in *.iso; do
    SLOT=$(basename "${file}" | cut -d'_' -f1)

    sudo conta --text --fs-options="umask=022" --non-interactive --mount --slot="${SLOT}" --password="$pass" "$file"
    if [[ $? == 1 ]]; then
        echo "Something went wrong!"
        exit 1
    fi
done

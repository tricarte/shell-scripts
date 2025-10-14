#!/usr/bin/env bash

sniploc="${HOME}/repos/sniploc-bulma-carton"
backupDest="${HOME}/backups/sites"

PIGZ=$(command -v pigz)
if [[ $PIGZ ]]; then
  TAR="tar -I ${PIGZ} -cf"
else
  TAR="tar czf"
fi

if [[ -d "${sniploc}" ]]; then
    if [[ ! -d "${backupDest}" ]]; then
        mkdir -p "${backupDest}"
    fi

    if [[ -f "${backupDest}/sniploc-bulma-carton.tar.gz" ]]; then
        rm -f "${backupDest}/sniploc-bulma-carton.tar.gz"
    fi

    $TAR "${backupDest}/sniploc-bulma-carton.tar.gz" --checkpoint=.100 "${sniploc}"

    if [[ -f "${backupDest}/sniploc-bulma-carton.tar.gz" ]]; then
        echo -e "\nSniploc backup created."
    else
        echo "Sniploc backup could not be created." 
        exit 1
    fi
else
    echo "Sniploc root could not be found."
    exit 1
fi

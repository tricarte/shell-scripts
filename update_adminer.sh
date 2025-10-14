#!/usr/bin/env bash

ADMPATH="${HOME}/valet-park/adminer"

if [[ ! -d "${ADMPATH}" ]]; then
	echo "${ADMPATH} does not exist!"
	exit 1
fi

if [[ -f "${ADMPATH}/index.php" ]]; then
	mv "${ADMPATH}/index.php" "${ADMPATH}/index.php.bak"
fi

wget -qO "${ADMPATH}/index.php" "https://www.adminer.org/latest-en.php"

if [[ -f "${ADMPATH}/index.php" ]]; then
	echo "adminer updated!"
fi

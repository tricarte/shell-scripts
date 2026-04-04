#!/usr/bin/env bash

ADMINER_ROOT="${HOME}/valet-park/adminer"

if [[ -f "${ADMINER_ROOT}/index.php" ]]; then
  current_version=$(grep -P '@version' "${ADMINER_ROOT}/index.php" | cut -d' ' -f3)
  if [[ -n "${current_version}" ]]; then
    echo "Checking for new version online..."
    wget -qO "/tmp/index_adminer.php" https://www.adminer.org/latest-en.php
    if [[ -f "/tmp/index_adminer.php" ]]; then
      new_version=$(grep -P '@version' "/tmp/index_adminer.php" | cut -d' ' -f3)
    else
      echo "adminer couldnot be downloaded!"
    fi

    if [[ "${new_version}" != "${current_version}" ]]; then
      if [[ -f "${ADMINER_ROOT}/index.php.bak" ]]; then
        rm -f "${ADMINER_ROOT}/index.php.bak"
      fi
      mv "${ADMINER_ROOT}/index.php" "index.php.bak"
      mv "/tmp/index_adminer.php" "${ADMINER_ROOT}/index.php"
    else
      echo "Already up to date!"
    fi
  else
    echo "Currently installed version could not be read!"
  fi
else
  echo "${ADMINER_ROOT}/index.php does not exist!"
fi

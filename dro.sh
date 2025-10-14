#!/usr/bin/env bash

# Drush wrapper

path="${1}"
shift

if [[ "${path}" == '.' ]]; then
  current=$PWD
  while [[ $current != "/" ]]; do
    if [[ -f "${current}/vendor/bin/drush" ]]; then
      doc_root="${current}"
      break
    else
      current=$(dirname "$current")
    fi
  done
else
  # Find the drupal site with that path
  search_path="${HOME}/repos/cms"

  # TODO: Hanlde multiple results correctly
  doc_root=$(find "${search_path}"/*"${path}"* -maxdepth 0 -type d)
  doc_root=$(printf '%s' "$doc_root" | head -n1)
fi

cd "${doc_root}" || exit

if [[ -f vendor/bin/drush.php ]]; then
  script='drush.php'
fi

if [[ -f vendor/bin/drush ]] && [[ ! -f vendor/bin/drush.php ]]; then
  script='drush'
fi

if [[ ! -f vendor/bin/drush ]] && [[ ! -f vendor/bin/drush.php ]]; then
  # TODO: notify-send
  echo "Drush could not be found in any ${search_path}/*${path}*."
  exit 1
fi

if [[ "${*}" == 'cl' ]]; then
  # Clear cache bins
  args="cc bin static,bootstrap,config,default,entity,menu,render,access_policy,data,discovery,dynamic_page_cache,jsonapi_normalizations,page,toolbar"
  if php845-drush -derror_reporting=8189 vendor/bin/"${script}" ${args}; then
    dir=$(basename "${doc_root}")
    if [ ! -t 0 ]; then
      notify-send --expire-time=3000 -a "${dir}" "drush ${args}" "has run successfully!"
    fi
  else
    notify-send --expire-time=3000 -a "${dir}" "drush ${*}" "did not run successfully!"
  fi

  # args=(drush theme-registry router css-js render plugin container token views)
  args=(theme-registry css-js render container token)
  for item in "${args[@]}"; do
    if php845-drush -derror_reporting=8189 vendor/bin/"${script}" cc "${item}"; then
    dir=$(basename "${doc_root}")
      if [ ! -t 0 ]; then
        notify-send --expire-time=3000 -a "${dir}" "drush cc ${item}" "has run successfully!"
      fi
    else
      notify-send --expire-time=3000 -a "${dir}" "drush ${*}" "did not run successfully!"
    fi
  done

  exit
elif [[ "${*}" == "uli" ]]; then
    dir=$(basename "${doc_root}")
    php845-drush -derror_reporting=8189 vendor/bin/"${script}" uli --uri="${dir}.test:8080"
    exit
else # Run whatever arguments passed to dro after shifting.
  if php845-drush -derror_reporting=8189 vendor/bin/"${script}" ${*}; then
    dir=$(basename "${doc_root}")
    if [ ! -t 0 ]; then
      notify-send -a "${dir}" "drush ${*}" "has run successfully!"
    fi
  else
    notify-send -a "${dir}" "drush ${*}" "did not run successfully!"
  fi
fi

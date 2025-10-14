#!/usr/bin/env bash
shopt -s globstar

WATCH_LIST=(
  "${HOME}/repos/static-php-cli/opcache-fpm-min-8-3/buildroot/bin/conf.d/*.conf"
  "${HOME}/repos/static-php-cli/opcache-fpm-min-8-3/buildroot/bin/php-fpm.conf"
  "${HOME}/repos/compiled-lighttpd-config/lighttpd-custom.conf"
  "${HOME}/repos/compiled-lighttpd-config/**/*.conf"
)

ls -1 "${WATCH_LIST[@]}" | entr -pc ${HOME}/bin/restart-custom-lemp.sh

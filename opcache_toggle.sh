#!/usr/bin/env bash

# Toggle opcache for the currently active valet-linux fpm.
# Use phpenmod/phpdismod instead.

action=$1

NOTIFYBIN=$(command -v notify-send)

# Output using notifybin if not running from interactive shell
function echo_message() {
  if [ -t 0 ]; then
    echo "OPCACHE: ${1}."
    if [[ -z $action ]]; then
      echo "Use '$(basename "$0") toggle' to toggle it from an interactive shell."
    fi
  else
    $NOTIFYBIN -a OPC "OPCACHE: ${1}." "Use '$(basename "$0") toggle' to toggle it from an interactive shell."
  fi
}

phpfpmversion=$(
  php -r "printf('%d.%d', PHP_MAJOR_VERSION, PHP_MINOR_VERSION);"
)

conf="/etc/php/${phpfpmversion}/fpm/pool.d/valet.conf"

if [[ -z $action ]]; then
  # Show opcache status
  if [[ $(grep 'opcache.enable' "$conf") == 'php_value[opcache.enable] = 0' ]]; then
    echo_message "Disabled"
  else
    echo_message "Enabled"
  fi
  exit
fi

if [[ $action == 'toggle' ]]; then
  if [[ -f $conf ]]; then
    if [[ $(grep 'opcache.enable' "$conf") == 'php_value[opcache.enable] = 0' ]]; then
      sudo replace 'php_value[opcache.enable] = 0' 'php_value[opcache.enable] = 1' -- "$conf"
      echo_message "Opcache enabled."
    else
      sudo replace 'php_value[opcache.enable] = 1' 'php_value[opcache.enable] = 0' -- "$conf"
      echo_message "Opcache disabled."
    fi
  fi

  valet restart
fi

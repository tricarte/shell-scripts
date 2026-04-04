#!/usr/bin/env bash

# Start mariadb
sudo systemctl restart mariadb

# Start lighttpd server
# kitten @ --to unix:/tmp/mykitty launch \
#     --keep-focus --hold --type=window \
#     --cwd "${HOME}/repos/lighttpd1.4" \
#     ./start_server

# Start php-fpm for Drupal
# kitten @ --to unix:/tmp/mykitty launch \
#     --keep-focus --hold --type=window \
#     --cwd "${HOME}/repos/static-php-cli/opcache-fpm-min-8-3/buildroot/bin" \
#     ./start-fpm-drupal-server

# TODO: kill existing servers first
# TODO: add restart capability
start_custom_lighttpd
start_fpm_drupal_server

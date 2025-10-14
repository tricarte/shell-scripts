#!/usr/bin/env bash

WORK_DIR="${HOME}/repos/compiled-fpm-config"
# PHP_FPM_BIN="php-fpm-845-drupal"
PHP_FPM_BIN="php-fpm-8313-drupal"

# -d=opcache.preload="/home/username/sites/wpsite/preload.php" \
# -d=opcache.preload_user=username \
# ./php-fpm-drupal -n --pid /tmp/custom-fpm.pid \
# -R or --allow-to-run-as-root
# -n Use no php.ini file
# -c Specify php.ini or the directory with configs.
# -g or --pid
# -y or --fpm-config
# --daemonize
# --nodaemonize \
# -t or --test Test configuration
# ./php-fpm-drupal -n \

# cd "${WORK_DIR}" || exit

env --chdir="${WORK_DIR}" -S "${PHP_FPM_BIN}" -n \
  -d opcache.enable=1 \
  -d xhprof.output_dir=/tmp \
  --daemonize \
  --fpm-config "${HOME}/repos/compiled-fpm-config/php-fpm.conf" \
  --prefix "${HOME}/repos/compiled-fpm-config/" \
  --pid "/tmp/${PHP_FPM_BIN}.pid"

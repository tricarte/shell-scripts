#!/usr/bin/env bash

WORK_DIR="${HOME}/repos/compiled-fpm-config"
# PHP_FPM_BIN="php-fpm-845-drupal"
# PHP_FPM_BIN="php-fpm-8313-drupal"
# PHP_FPM_BIN="php8.5-fpm-spc" # 32.42 32.77 32.09
# PHP_FPM_BIN="php8.5-fpm-mtune-march-no-ini" # 32.30 31.67 30.65
PHP_FPM_BIN="php8.5-fpm-mtune-no-ini" # 30.88 30.89 30.83 4893 4902 4885
# PHP_FPM_BIN="php8.5-fpm-O3g0-no-ini" # 30.67 29.53 30.76 4878 4865 4863
# Lighttpd + luajit + fpm = O3 g0 mtune=native
# mako.test:8080/
# 4922 (29.60) 4918 (29.50) 4875 (30.75)
# mako.test:8080/view
# 4409 (32.56) 4420 (32.92) 4451 (32.43)
# mako.test:8080/query
# 2962 (49.63) 2967 (48.36) 2960 (48.64)

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

# -d xhprof.output_dir=/tmp \
env --chdir="${WORK_DIR}" -S "${PHP_FPM_BIN}" -n \
  -d opcache.enable=1 \
  -d opcache.jit=tracing \
  -d opcache.max_accelerated_files=10000 \
  -d opcache.memory_consumption=128 \
  -d opcache.interned_strings_buffer=16 \
  -d opcache.enable_file_override=1 \
  -d opcache.validate_timestamps=0 \
  -d opcache.validate_permission=0 \
  -d opcache.jit_buffer_size=32M \
  --daemonize \
  --fpm-config "${HOME}/repos/compiled-fpm-config/php-fpm.conf" \
  --prefix "${HOME}/repos/compiled-fpm-config/" \
  --pid "/tmp/${PHP_FPM_BIN}.pid"

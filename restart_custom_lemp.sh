#!/usr/bin/env bash

# FPM_PID=$(pgrep -f "php-fpm: master process" | tail -n1)
# LIGHTY_PID=$(pgrep -f "lighttpd-custom.conf" | head -n1)
# kill -SIGUSR2 ${FPM_PID}
# kill -SIGUSR1 ${LIGHTY_PID}

LPIDFILE="/tmp/custom-lighttpd.pid"
# FPIDFILE="/tmp/php-fpm-845-drupal.pid"
# FPIDFILE="/tmp/php8.5-fpm-spc.pid"
FPIDFILE="/tmp/php8.5-fpm-mtune-no-ini.pid"
# FPIDFILE="/tmp/php8.5-fpm-mtune-march-no-ini.pid"
# FPIDFILE="/tmp/php8.5-fpm-O3g0-no-ini.pid"
# FPIDFILE="php-fpm-8313-drupal"

if [[ -f "${LPIDFILE}" ]]; then
  LPID=$(cat "${LPIDFILE}")
  kill -SIGUSR1 "${LPID}"
fi

if [[ -f "${FPIDFILE}" ]]; then
  FPID=$(cat "${FPIDFILE}")
  kill -SIGUSR2 "${FPID}"
fi

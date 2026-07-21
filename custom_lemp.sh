#!/usr/bin/env bash

# Set the basename of the php-fpm server binary
# This will be the php-fpm PID file: /tmp/{PHP_FPM_BIN}.pid
PHP_FPM_BIN="current-fpm"

start_lemp_cl() {
  start_fpm_cl
  start_lighttpd_cl
}

stop_lemp_cl() {
  stop_lighttpd_cl
  stop_fpm_cl
}

restart_lemp_cl() {
  restart_fpm_cl
  restart_lighttpd_cl
}

start_lighttpd_cl() {
  pid_f="/tmp/custom-lighttpd.pid"

  if [[ -f "${pid_f}" ]]; then
    pid=$(cat "${pid_f}")
    echo "lighttpd already running at PID: (${pid})"
    return 1
  fi

  "${LIGHTTPD_WORK_DIR}/src/lighttpd" \
    -f "${HOME}/repos/compiled-lighttpd-config/lighttpd.conf" \
    -m "${LIGHTTPD_WORK_DIR}"/src/.libs

  if [[ -f "${pid_f}" ]]; then
    pid=$(cat "${pid_f}")
    echo "lighttpd running at PID: (${pid})"
    return 1
  fi
}

stop_lighttpd_cl() {
  pid_f="/tmp/custom-lighttpd.pid"

  if [[ -f "${pid_f}" ]]; then
    pid=$(cat "${pid_f}")
    kill -term "${pid}"
  else
    echo "PID file (${pid_f}) could not be found!"
    return 1
  fi
}

restart_lighttpd_cl() {
  stop_lighttpd_cl
  sleep 1
  start_lighttpd_cl
}

start_fpm_cl() {
  pid_f="/tmp/${PHP_FPM_BIN}.pid"

  if [[ -f "${pid_f}" ]]; then
    pid=$(cat "${pid_f}")
    echo "FPM already running at PID: (${pid})"
    return 1
  fi

  env --chdir="${FPM_WORK_DIR}" -S "${PHP_FPM_BIN}" -n \
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

  if [[ -f "${pid_f}" ]]; then
    pid=$(cat "${pid_f}")
    echo "FPM running at PID: (${pid})"
    return 1
  fi
}

stop_fpm_cl() {
  pid_f="/tmp/${PHP_FPM_BIN}.pid"

  if [[ -f "${pid_f}" ]]; then
    pid=$(cat "${pid_f}")
    kill -term "${pid}"
  else
    echo "PID file (${pid_f}) could not be found!"
    return 1
  fi
}

restart_fpm_cl() {
  stop_fpm_cl
  sleep 1
  start_fpm_cl
}

which_cl() {
  slink="${HOME}/bin/current-fpm"
  if [[ -f "${slink}" ]]; then
    echo $(basename $(readlink -f "${slink}"))
  else
    echo "${slink} does not exist!"
    return 1
  fi
}

main_cl() {
  act="${1}"
  FPM_WORK_DIR="${HOME}/repos/compiled-fpm-config"
  LIGHTTPD_WORK_DIR="${HOME}/repos/lighttpd1.4"

  case "${action}" in
  start)
    start_lemp_cl
    ;;
  stop)
    stop_lemp_cl
    ;;
  restart)
    restart_lemp_cl
    ;;
  which)
    which_cl
    ;;
  *)
    echo "Usage: $(basename $0) {start|stop|restart|which}"
    exit 1
    ;;
  esac

}

action="${1}"
main_cl "${action}"

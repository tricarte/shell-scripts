#!/usr/bin/env bash

# export LD_LIBRARY_PATH=/home/username/luajit21/lib:$LD_LIBRARY_PATH
# -D: DO NOT daemonize. By default, it daemonizes
cd "${HOME}/repos/lighttpd1.4" || exit
src/lighttpd -f "${HOME}/repos/compiled-lighttpd-config/lighttpd.conf" -m "${PWD}"/src/.libs

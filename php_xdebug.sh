#!/usr/bin/env bash
# Debug a PHP script from wihtin CLI.
# export XDEBUG_CONFIG="idekey=netbeans-xdebug"
export XDEBUG_SESSION=1
/usr/bin/php "$@"

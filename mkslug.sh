#!/usr/bin/env bash
# TODO: This does not handle accented characters

# fixed=$(printf '%s' "${*}" | tr -s ' ' | tr ' ' '_')
# fixed=$(printf '%s' "${fixed}" | sed 's/[^(^(-_)a-zA-Z0-9)]//g' | tr -s '_-')
# printf '%s' "${fixed}"

printf '%s' "${*}" | sed -e 's/[^0-9a-zA-Z ._-]//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/  */-/g'

#!/usr/bin/env bash
# TODO: how to accept stdin
PARAMS=""
while (("$#")); do
  case "$1" in
  --rel-paths)
    RELPATHS=1
    shift # Pop the first element off the array on each iteration.
    ;;
  *) # preserve positional arguments
    PARAMS="$PARAMS \"$1\""
    shift
    ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ -z $1 ]]; then
  echo ""
  echo "Will wrap each new-line-separated input with double quotes."
  echo "Usage: wrap-with-quotes [--rel-paths] \"\$multilineString\""
  exit
fi

IFS=$'\n'
for item in $1; do
  if [[ $RELPATHS ]]; then
    echo \""$(realpath --relative-to="$PWD" "$item")"\"
  else
    echo \""$item"\"
  fi
done

unset IFS

#!/usr/bin/env bash
PARAMS=""
DEVICE="linux"
TARGET="${PWD}/lib/main.dart"
while (( "$#" )); do
case "$1" in
    -d|--device)
        if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
            DEVICE=$2
            shift 2
        else
            _e "Error: Argument for $1 is missing" >&2
            exit 1
        fi
        ;;
    -t|--target)
        if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
            TARGET=$2
            shift 2
        else
            _e "Error: Argument for $1 is missing" >&2
            exit 1
        fi
        ;;
    --*|-*) # unsupported flags
        _e "Error: Unsupported flag $1" >&2
        exit 1
        ;;
    *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ ! -f "${TARGET}" ]]; then
    echo "${TARGET} does not exist!"
    exit 1
fi

# flutter run -d "${device}" "${target}" --pid-file="/tmp/flutter_$(echo "${target}" | base64).pid"
appname=$(basename "${PWD}")
flutter run -d "${DEVICE}" "${TARGET}" --pid-file="/tmp/flutter_${appname}.pid"

#!/usr/bin/env bash

# Read settings from encrypted file
# CONFIG=$(gpg -qd --pinentry-mode loopback "${HOME}/.socks_settings.gpg")
CONFIG=$(gpg -qd "${HOME}/.socks_settings.gpg")

PWORD=$(printf '%s' "${CONFIG}" | cut -d' ' -f1)
HOST=$(printf '%s' "${CONFIG}"  | cut -d' ' -f2)
LOCAL_PORT=$(printf '%s' "${CONFIG}" | cut -d' ' -f3)

shadowsocks2-linux -c "ss://AEAD_AES_128_GCM:${PWORD}@${HOST}" \
    -verbose -socks :"${LOCAL_PORT}" -u \
    -udptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 \
    -tcptun :8053=8.8.8.8:53,:8054=8.8.4.4:53

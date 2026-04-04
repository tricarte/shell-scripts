#!/usr/bin/env bash

for file in "${@}"; do
  file=$(realpath "${file}")
  /opt/nvim-linux-x86_64/bin/nvim --noplugin \
    --cmd "lua vim.fn.rpcrequest(vim.fn.sockconnect('pipe', '/tmp//nvim.server.pipe', { rpc = true }), 'nvim_command', ':e! ${file}')" \
    --cmd "q" --headless
done

#!/usr/bin/env bash

file="${1}"
line="${2}"

file=$(realpath "${file}")
/opt/nvim-linux-x86_64/bin/nvim --noplugin \
  --cmd "lua vim.fn.rpcrequest(vim.fn.sockconnect('pipe', '/tmp//nvim.server.pipe', { rpc = true }), 'nvim_command', ':e! +${line} ${file}')" \
  --cmd "q" --headless

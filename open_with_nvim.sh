#!/usr/bin/env bash

for file in "${@}"; do
  # Skip binary files
  # FIXME: returns binary even for empty text files
  # ftype="$(file --mime-encoding ${f} | cut -d ' ' -f2)"
  # if [[ "${ftype}" =~ binary$ ]]; then
  #   continue
  # fi
  file=$(realpath "${file}")
  /opt/nvim-linux-x86_64/bin/nvim --noplugin \
    --cmd "lua vim.fn.rpcrequest(vim.fn.sockconnect('pipe', '/tmp/nvim.server.pipe', { rpc = true }), 'nvim_command', ':e! ${file}')" \
    --cmd "q" --headless
done

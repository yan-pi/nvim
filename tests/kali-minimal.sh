#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
app_name=${NVIM_APPNAME:-nvim-kali-test}

export NVIM_APPNAME="$app_name"

nvim --headless -u "$root/init.lua" \
  -c "lua dofile('$root/tests/kali-minimal.lua')" \
  -c 'qa!'

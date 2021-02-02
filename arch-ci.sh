#!/bin/bash
set -e
set -o pipefail
set -o xtrace

luarocks --lua-version=5.1 --local make
eval $(luarocks --lua-version=5.1 --local path)

cat $(which busted) | sed 's/\/usr\/bin\/lua5\.1/\/usr\/local\/openresty\/luajit\/bin\/luajit/' > busted
chmod +x busted

./busted -o utfTerminal
./busted -o utfTerminal spec_gm
make lint

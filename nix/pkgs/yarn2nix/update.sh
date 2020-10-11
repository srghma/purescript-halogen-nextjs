#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
nix-prefetch-git https://github.com/moretea/yarn2nix > "$SCRIPT_DIR/revision.json"
# nix-prefetch-git https://github.com/srghma/yarn2nix --rev f559fc67c80204931444227d95f93d02161f2570 > "$SCRIPT_DIR/revision.json"

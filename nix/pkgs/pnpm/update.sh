#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
nix-prefetch-git https://github.com/srghma/nixpkgs --rev 7ea948f912efda9b85b3f6ed1ad9810ff995b298 --no-deepClone > "$SCRIPT_DIR/revision.json"

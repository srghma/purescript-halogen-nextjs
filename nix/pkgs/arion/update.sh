#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
# nix-prefetch-git https://github.com/hercules-ci/arion --rev cc9e70a2ccdacb435c835079b9d473683ac0639b > "$SCRIPT_DIR/revision.json"
nix-prefetch-git https://github.com/hercules-ci/arion > "$SCRIPT_DIR/revision.json"
# nix-prefetch-git https://github.com/srghma/arion --rev 108767c03231cfd9bde6c06df122f08563f77cb2 > "$SCRIPT_DIR/revision.json"

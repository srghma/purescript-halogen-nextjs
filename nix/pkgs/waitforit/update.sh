#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
version="v2.4.1"

urlLinux="https://github.com/maxcnunes/waitforit/releases/download/$version/waitforit-linux_amd64"
urlDarwin="https://github.com/maxcnunes/waitforit/releases/download/$version/waitforit-darwin_amd64"

#########

sha256=$(nix-prefetch-url --type sha256 $urlLinux)

cat > $SCRIPT_DIR/revisionLinux.json <<EOL
{
  "version": "$version",
  "sha256": "$sha256",
  "url": "$urlLinux"
}
EOL

#########

sha256=$(nix-prefetch-url --type sha256 $urlDarwin)

cat > $SCRIPT_DIR/revisionDarwin.json <<EOL
{
  "version": "$version",
  "sha256": "$sha256",
  "url": "$urlDarwin"
}
EOL

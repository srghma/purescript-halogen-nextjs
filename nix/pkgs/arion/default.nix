{ pkgs, fetchFromGitHub, readRevision, ... }:

# let
#   src = fetchFromGitHub (
#     readRevision ./revision.json
#   );

#   # src = /home/srghma/projects/arion;

#   arion = pkgs.callPackage "${src}/arion.nix" {};
#   # arion = (import src {}).arion;
# in
#   arion

(import (builtins.fetchTarball https://github.com/hercules-ci/arion/tarball/master) {}).arion

{ pkgs }:

let

config = rec {
  # type Name = String
  # type Code = String
  # Map Name Code -> List Pkg
  mkScripts = attrsetOfNamesAndCode: pkgs.lib.attrValues (pkgs.lib.mapAttrs (name: code: pkgs.writeShellScriptBin name code) attrsetOfNamesAndCode);
};

in

builtins.concatLists [
  # (import ./feature-tests-dev/default.nix { inherit pkgs config; })
  (import ./import/default.nix { inherit pkgs config; })
]

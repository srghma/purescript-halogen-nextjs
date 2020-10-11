{ lib, ... }:

with lib;

let

exportEnvsCommand = attrs: builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "export " + name + "=" + builtins.toString value) attrs);

in

exportEnvsCommand

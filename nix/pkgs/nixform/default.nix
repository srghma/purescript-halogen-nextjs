{ pkgs, ... }:

let
  terraform = pkgs.terraform.withPlugins (p: with p; [ aws tls local ]);

  revData = builtins.fromJSON (builtins.readFile ./revision.json);

  src = builtins.fetchTarball {
    inherit (revData) sha256;
    url = "${revData.url}/archive/${revData.rev}.tar.gz";
  };
in
  pkgs.callPackage "${src}/default.nix" { inherit terraform; }

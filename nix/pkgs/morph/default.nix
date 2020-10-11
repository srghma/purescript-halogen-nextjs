{ pkgs, fetchFromGitHub, readRevision, ... }:

let
  revData = readRevision ./revision.json;

  src = fetchFromGitHub {
    inherit (revData) rev sha256 owner repo;
  };
in
  pkgs.callPackage "${src}/nix-packaging/default.nix" { }

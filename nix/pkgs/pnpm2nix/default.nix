{ pkgs, fetchFromGitHub, readRevision, ... }:

let
  src = fetchFromGitHub (
    readRevision ./revision.json
  );

  pnpm2nix = pkgs.callPackage "${src}/default.nix" {};
in
  pnpm2nix

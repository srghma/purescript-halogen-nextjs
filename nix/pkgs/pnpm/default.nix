{ fetchFromGitHub, readRevision, ... }:

let
  nixpkgs = fetchFromGitHub (
    readRevision ./revision.json
  );

  pkgs = import nixpkgs { config = { allowUnfree = true; }; };
in
  pkgs.nodePackages_10_x.pnpm

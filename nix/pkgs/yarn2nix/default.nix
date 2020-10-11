{ pkgs, fetchFromGitHub, readRevision, ... }:

let
  src = fetchFromGitHub (
    readRevision ./revision.json
  );

  # src = ~/projects/yarn2nix;

  src_ = import src { inherit pkgs; };
in
  src_

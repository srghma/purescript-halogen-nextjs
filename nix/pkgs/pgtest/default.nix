{ fetchFromGitHub, lib, readRevision }:

let
  revData = readRevision ./revision.json;

  src = fetchFromGitHub {
    inherit (revData) rev sha256 owner repo;
  };
in
  src

{ runCommand, fetchFromGitHub, lib, readRevision, ... }:

let
  src = fetchFromGitHub (
    readRevision ./revision.json
  );
in
  import src { inherit lib runCommand; }

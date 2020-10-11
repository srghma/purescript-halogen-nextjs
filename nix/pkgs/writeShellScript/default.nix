{ pkgs }:

name: text:
  pkgs.writeTextFile {
    inherit name;

    executable = true;

    text = ''
      #!${pkgs.stdenv.shell} -eu
      ${text}
      '';

    checkPhase = ''
      ${pkgs.stdenv.shell} -n $out
    '';
  }

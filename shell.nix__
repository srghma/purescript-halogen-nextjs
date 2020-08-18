{ pkgs ? import <nixos> {} }:


let
  mypkgs = import /home/srghma/projects/nixpkgs {};

  mwc-source = builtins.fetchGit git://github.com/material-components/material-components-web-components;

  mwcNodeModules = pkgs.stdenv.mkDerivation {
    __noChroot = true; # disabled sandbox and adds access to network for npm when "--option sandbox relaxed"

    name = "mwc-deps";

    src = mwc-source;

    buildInputs = with pkgs; [nodejs git];

    dontInstall = true;

    buildPhase = ''
      mkdir $out

      cp $src/package.json $out/
      cp $src/package-lock.json $out/

      cd $out

      # disable postinstall
      HOME=. npm install --ignore-scripts

      rm -f $out/package.json $out/package-lock.json
    '';
  };

  mwc = pkgs.stdenv.mkDerivation {
    __noChroot = true; # disabled sandbox and adds access to network for npm when "--option sandbox relaxed"

    name = "mwc";

    src = mwc-source;

    buildInputs = with pkgs; [nodejs git];

    phases = "buildPhase";
    dontInstall = true;

    buildPhase = ''
      mkdir $out

      cp -r $src/* $out

      cd $out

      chmod -R 1777 ./scripts/
      patchShebangs ./scripts/

      cp -r ${mwcNodeModules}/node_modules $out/node_modules

      ls -al

      HOME=. npm run bootstrap
      HOME=. npm run build
    '';
  };
in
  mwc
  # pkgs.mkShell rec {
  #   shellHook = ''
  #     ls -al ${mwc}
  #   '';
  # }

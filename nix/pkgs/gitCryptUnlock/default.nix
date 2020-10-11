{ pkgs, ... }:

let
  inherit (pkgs) stdenv git-crypt git;
in

key:
src:
stdenv.mkDerivation {
  name = "decrypted-source";
  inherit src;
  buildInputs = [ git-crypt git ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out

    # copy content of folder with hidden files to $out
    cp -r $src/. $out

    cd $out

    # git crypt requires git
    git init

    # set only for this repo
    git config user.email "you@example.com"
    git config user.name "Your Name"

    git add --all
    git commit --quiet -m "dummy"

    # prevent "error: unable to unlink old... permission denied"
    # see https://stackoverflow.com/questions/11774397/git-push-error-unable-to-unlink-old-permission-denied/11774432
    chmod -R +w $out

    git-crypt unlock ${key}

    # don't leave traces
    rm -rfd .git
  '';
}

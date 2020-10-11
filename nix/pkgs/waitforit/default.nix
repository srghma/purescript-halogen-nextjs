{ stdenv, fetchurl }:

let
  revDataLinux = builtins.fromJSON (builtins.readFile ./revisionLinux.json);
  revDataDarwin = builtins.fromJSON (builtins.readFile ./revisionDarwin.json);

  revData = if stdenv.isLinux then revDataLinux else revDataDarwin;

  inherit (revData) url version sha256;

  program = fetchurl {
    inherit url sha256;
  };
in

stdenv.mkDerivation {
  name = "waitforit-${version}";

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp ${program} $out/bin/waitforit
    chmod +x $out/bin/waitforit
  '';

  meta.platforms = stdenv.lib.platforms.all;
}

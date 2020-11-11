{ stdenv, lib, makeWrapper, postgresql, coreutils }:

stdenv.mkDerivation rec {
  name = "dump-schema";

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    cp ${./dump-schema} $out/dump-schema

    patchShebangs $out/dump-schema

    makeWrapper $out/dump-schema $out/bin/${name} \
      --prefix PATH : ${lib.makeBinPath [ postgresql coreutils ]}
  '';
}

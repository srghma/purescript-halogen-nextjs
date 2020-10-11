{ stdenv, lib, makeWrapper, docker }:

stdenv.mkDerivation rec {
  name = "docker-volume-rm-if-exists";

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${./docker-volume-rm-if-exists} $out/bin/${name} \
      --prefix PATH : ${lib.makeBinPath [ docker ]}
  '';
}

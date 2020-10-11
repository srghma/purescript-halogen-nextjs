{ stdenv, lib, makeWrapper, postgresql, coreutils }:

stdenv.mkDerivation rec {
  name = "wait-for-postgres";

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    cp ${./wait-for-postgres} $out/wait-for-postgres

    patchShebangs $out/wait-for-postgres

    makeWrapper $out/wait-for-postgres $out/bin/${name} \
      --prefix PATH : ${lib.makeBinPath [ postgresql coreutils ]}
  '';
}

{ stdenv, postgresql, perlPackages, makeWrapper, lib }:

# pgql is required to be in $PATH (https://github.com/NixOS/nixpkgs/issues/55663)
stdenv.mkDerivation rec {
  name = "pg_prove";

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${perlPackages.TAPParserSourceHandlerpgTAP}/bin/pg_prove $out/bin/pg_prove \
      --prefix PATH : ${lib.makeBinPath [ postgresql ]}

    makeWrapper ${perlPackages.TAPParserSourceHandlerpgTAP}/bin/pg_tapgen $out/bin/pg_tapgen \
      --prefix PATH : ${lib.makeBinPath [ postgresql ]}
  '';
}

pkgs: pkgsOld:
{
  rootProjectDir             = toString ../..;
  mylib                      = pkgs.callPackage ./mylib {};
  gitCryptUnlock             = pkgs.callPackage ./gitCryptUnlock {};
  makeDockerComposeFile      = pkgs.callPackage ./makeDockerComposeFile {};
  opensslDecrypt             = pkgs.callPackage ./opensslDecrypt {};
  writeShellScript           = pkgs.callPackage ./writeShellScript {};
  arion                      = pkgs.callPackage ./arion {};
  arionEvaluate              = pkgs.callPackage ./arionEvaluate {};
  gitignore                  = pkgs.callPackage ./nix-gitignore {};
  readRevision               = pkgs.callPackage ./readRevision {};
  yarn2nix                   = pkgs.callPackage ./yarn2nix {};
  waitforit                  = pkgs.callPackage ./waitforit {};
  wait-for-postgres          = pkgs.callPackage ./wait-for-postgres {};
  dump-schema                = pkgs.callPackage ./dump-schema {};
  minio-set-bucket-policies  = pkgs.callPackage ./minio-set-bucket-policies {};
  docker-volume-rm-if-exists = pkgs.callPackage ./docker-volume-rm-if-exists {};
  db-tests-prepare           = pkgs.callPackage ./db-tests-prepare {};
  pgtest                     = pkgs.callPackage ./pgtest {};
  shmig                      = pkgs.callPackage ./shmig { withPSQL = true; withMySQL = false; };
  # shmig                         = pkgs.callPackage "${<nixpkgs-master>}/pkgs/development/tools/database/shmig" { withPSQL = true; withMySQL = false; };
  pnpm2nix                   = pkgs.callPackage ./pnpm2nix {};
  pnpm                       = pkgs.callPackage ./pnpm {};
  pg_prove                   = pkgs.callPackage ./pg_prove {};
  nixform                    = pkgs.callPackage ./nixform {};
  morph                      = pkgs.callPackage ./morph {};
  ntmuxp                     = pkgs.callPackage ./ntmuxp {};
  postgresql                 = pkgs.postgresql_13;
}

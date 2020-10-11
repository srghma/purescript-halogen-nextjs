{ pkgs, ... }:

with pkgs;

let
  rootProjects = import "${rootProjectDir}/default.nix" { inherit pkgs; };

  inherit (rootProjects) rootYarnModules;
in

{
  config = {
    docker-compose = {
      raw = {
        volumes = {
          postgres_data = null;
        };
      };
    };

    services = {
      postgres = {
        service = pkgs.mylib.recursiveMerge [
          (import ./common/postgres.nix { })
          {
            container_name = "nextjsdemopostgres";

            ports = [
              "5432:5432"
            ];
          }
        ];
      };

      migrator = {
        service = import ./common/migrator.nix { inherit pkgs rootProjectDir; };
      };

      db_tests = {
        service = pkgs.mylib.recursiveMerge [
          (import ./common/db_tests.nix { inherit pkgs rootProjectDir; })
          {
            command = "${pkgs.coreutils}/bin/true"; # do nothing on `docker-compose up`

            # command = [
            #   "sh" "-eux" "-c" ''
            #     waitforit -host=$$POSTGRES_HOST -port=$$POSTGRES_PORT -timeout=30 &&
            #     db-tests-prepare /db_tests/extensions &&
            #     pg_prove -h $$POSTGRES_HOST -p $$POSTGRES_PORT -d $$POSTGRES_DB -U $$POSTGRES_USER --recurse --ext .sql /db_tests/tests/
            #   ''
            # ];

            environment = rec {
              PATH =
                let
                  env = pkgs.buildEnv {
                    name = "system-path";
                    paths = with pkgs; [
                      waitforit
                      db-tests-prepare
                      pg_prove
                    ];
                  };
                in "${env}/bin:/bin:/run/system/bin";
            };
          }
        ];
      };
    };
  };
}

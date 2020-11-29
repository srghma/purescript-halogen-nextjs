{ pkgs, ... }:

with pkgs;

let
  mkInitDbScript = import ./utils/mkInitDbScript.nix { inherit pkgs; };

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
      pgadmin = {
        service = import ./common/pgadmin.nix {};
      };

      postgres = {
        service =
          {
            image = "postgres:13";

            volumes = [
              "postgres_data:/var/lib/postgresql/data"
              "${mkInitDbScript
              {
                isProduction = false;

                inherit (import "${rootProjectDir}/config/public/database.nix") DATABASE_NAME;

                inherit (import "${rootProjectDir}/config/ignored/passwords.nix") DATABASE_OWNER_PASSWORD DATABASE_ANONYMOUS_PASSWORD;
              }
              }:/docker-entrypoint-initdb.d/init.sh"
            ];

            environment = {
              inherit (import "${rootProjectDir}/config/public/database.nix") POSTGRES_USER;
              inherit (import "${rootProjectDir}/config/ignored/passwords.nix") POSTGRES_PASSWORD;
            };

            container_name = "nextjsdemopostgres";

            ports = [
              "5432:5432"
            ];
          };
      };
    };
  };
}

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
    };
  };
}

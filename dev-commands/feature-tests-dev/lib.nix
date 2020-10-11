{ pkgs, config }:

with config;

let
  POSTGRES_HOST = "0.0.0.0";
  POSTGRES_PORT = 5432;

  SERVER_HOST = "0.0.0.0";
  SERVER_PORT = 5000;

  CLIENT_HOST = "0.0.0.0";
  CLIENT_PORT = 3000;
in

{
  rootEnv = ''
    set -eux

    cd ${pkgs.rootProjectDir}
  '';

  migratorEnv =
    let
      working_dir = "migrations";

      environment = {
        TYPE     = "postgresql";
        LOGIN    = "app_admin";
        PASSWORD = "app_admin_pass";
        HOST     = POSTGRES_HOST;
        PORT     = POSTGRES_PORT;
        DATABASE = "nextjsdemo_test";

        PATH = let
          env = pkgs.buildEnv {
            name = "system-path";
            paths = with pkgs; [
              waitforit
              wait-for-postgres
              shmig
            ];
          };
        in "${env}/bin:/bin:/run/system/bin";
      };
    in ''
      set -eux

      cd ${pkgs.rootProjectDir}/${working_dir}

      ${pkgs.mylib.exportEnvsCommand environment}
    '';

  serverEnv =
    let
      working_dir = "packages/server";

      environment = rec {
        POSTGRES_USER     = "app_admin";
        POSTGRES_PASSWORD = "app_admin_pass";
        inherit POSTGRES_HOST;
        inherit POSTGRES_PORT;
        POSTGRES_DB       = "nextjsdemo_test";

        PORT              = SERVER_PORT;
        HOST              = SERVER_HOST;
        EXPOSED_SCHEMA    = "app_public";
        NODE_ENV          = "development";
        DATABASE_URL      = "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${toString POSTGRES_PORT}/${POSTGRES_DB}";
        JWT_SECRET        = "change_me";
        CORS_ALLOW_ORIGIN = "*";

        EXPORT_GQL_SCHEMA  = "${pkgs.rootProjectDir}/schemas/schema.graphql";
        EXPORT_JSON_SCHEMA = "${pkgs.rootProjectDir}/schemas/schema.json";
        BABEL_CACHE_PATH   = "/tmp/babel-cache"; # by default babel-node will cache to node_modules/.cache, but in our case it's read-only
        GRAPHILE_LICENSE   = import "${pkgs.rootProjectDir}/config/ignored/graphile-license.nix";
      };
  in ''
    set -eux

    cd ${pkgs.rootProjectDir}/${working_dir}

    ${pkgs.mylib.exportEnvsCommand environment}
    '';

  clientEnv =
    let
      working_dir = "packages/client";

      environment = rec {
        inherit SERVER_HOST;
        inherit SERVER_PORT;

        # NEXT_STATIC_ - embedded in the js bundles on build time
        NEXT_STATIC_GRAPHQL_ENDPOINT_URL = "http://${SERVER_HOST}:${toString SERVER_PORT}/graphql";
        NEXT_STATIC_GRAPHQL_WEBSOCKET_ENDPOINT_URL = "ws://${SERVER_HOST}:${toString SERVER_PORT}/graphql";
        NEXT_STATIC_SECURE_COOKIES = "false";

        # NEXT_SERVER_ - visible only during ssr
        NEXT_SERVER_GRAPHQL_ENDPOINT_URL = "http://${SERVER_HOST}:${toString SERVER_PORT}/graphql";

        HOST = CLIENT_HOST;
        PORT = CLIENT_PORT;
      };
  in ''
    set -eux

    cd ${pkgs.rootProjectDir}/${working_dir}

    ${pkgs.mylib.exportEnvsCommand environment}
    '';

  featureTestsEnv =
    let
      working_dir = "packages/feature-tests";

      environment = rec {
        inherit SERVER_HOST;
        inherit SERVER_PORT;

        inherit CLIENT_HOST;
        inherit CLIENT_PORT;

        CLIENT_URL        = "http://${CLIENT_HOST}:${toString CLIENT_PORT}";

        POSTGRES_USER     = "app_admin";
        POSTGRES_PASSWORD = "app_admin_pass";
        inherit POSTGRES_HOST;
        inherit POSTGRES_PORT;
        POSTGRES_DB       = "nextjsdemo_test";

        MAILHOG_HOST      = "0.0.0.0";
        MAILHOG_PORT      = 8025;
        MAILHOG_URL       = "http://${MAILHOG_HOST}:${toString MAILHOG_PORT}";

        CHROMEDRIVER_PATH = "${pkgs.chromedriver}/bin/chromedriver";
        CHROME_PATH       = "$(which google-chrome-stable)";

        BABEL_CACHE_PATH = "/tmp/babel-cache"; # by default babel-node will cache to node_modules/.cache, but in our case it's read-only
      };
    in ''
      set -eux

      cd ${pkgs.rootProjectDir}/${working_dir}

      ${pkgs.mylib.exportEnvsCommand environment}
    '';
}

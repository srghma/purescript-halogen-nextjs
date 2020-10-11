{ pkgs }:

let
  POSTGRES_HOST     = "0.0.0.0";
  POSTGRES_PORT     = 5432;
  POSTGRES_USER     = "app_admin";
  POSTGRES_PASSWORD = "app_admin_pass";
  POSTGRES_DB       = "nextjsdemo_test";

  SERVER_HOST = "0.0.0.0";
  SERVER_PORT = 5000;

  CLIENT_HOST = "0.0.0.0";
  CLIENT_PORT = 3000;
in

rec {
  migratorEnv =
    rec {
      inherit POSTGRES_HOST POSTGRES_PORT POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB;
    };

  serverEnv =
    rec {
      inherit POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB POSTGRES_HOST POSTGRES_PORT;

      PORT              = SERVER_PORT;
      HOST              = SERVER_HOST;
      EXPOSED_SCHEMA    = "app_public";
      NODE_ENV          = "development";
      DATABASE_URL      = "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${toString POSTGRES_PORT}/${POSTGRES_DB}";
      JWT_SECRET        = "change_me";
      CORS_ALLOW_ORIGIN = "*";

      EXPORT_GQL_SCHEMA  = "${pkgs.rootProjectDir}/schemas/schema.graphql";
      EXPORT_JSON_SCHEMA = "${pkgs.rootProjectDir}/schemas/schema.json";
      # BABEL_CACHE_PATH   = "/tmp/babel-cache"; # by default babel-node will cache to node_modules/.cache, but in our case it's read-only
      GRAPHILE_LICENSE   = import "${pkgs.rootProjectDir}/config/ignored/graphile-license.nix";
    };
}

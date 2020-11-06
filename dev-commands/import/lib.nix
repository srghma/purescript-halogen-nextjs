{ pkgs }:

with pkgs;

let
  inherit (import "${rootProjectDir}/config/public/database.nix")
    # DATABASE_OWNER
    DATABASE_OWNER
    DATABASE_AUTHENTICATOR
    DATABASE_VISITOR
    DATABASE_NAME;

  inherit (import "${rootProjectDir}/config/ignored/passwords.nix")
    # DATABASE_OWNER_PASSWORD
    DATABASE_OWNER_PASSWORD
    DATABASE_AUTHENTICATOR_PASSWORD
    SESSION_SECRET
    JWT_SECRET;

  POSTGRES_HOST     = "0.0.0.0";
  POSTGRES_PORT     = 5432;

  SERVER_HOST = "0.0.0.0";
  SERVER_PORT = 5000;

  CLIENT_HOST = "0.0.0.0";
  CLIENT_PORT = 3000;
in

rec {
  migratorEnv =
    rec {
      inherit
        DATABASE_OWNER
        DATABASE_OWNER_PASSWORD
        DATABASE_NAME
        POSTGRES_HOST
        POSTGRES_PORT;
    };

  serverEnv =
    rec {
      inherit
        DATABASE_OWNER
        DATABASE_OWNER_PASSWORD
        DATABASE_NAME
        POSTGRES_HOST
        POSTGRES_PORT;
    };
}

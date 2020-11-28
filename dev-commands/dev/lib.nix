{ pkgs }:

rec {
  config =
    {
      POSTGRES_HOST = "0.0.0.0";
      POSTGRES_PORT = 5432;

      SERVER_HOST = "0.0.0.0";
      SERVER_PORT = 5000;

      CLIENT_HOST = "0.0.0.0";
      CLIENT_PORT = 3000;
    };

  migratorEnv =
    {
      inherit (import "${pkgs.rootProjectDir}/config/public/database.nix")
        DATABASE_OWNER
        DATABASE_NAME;

      inherit (import "${pkgs.rootProjectDir}/config/ignored/passwords.nix")
        DATABASE_OWNER_PASSWORD;

      inherit (config)
        POSTGRES_HOST
        POSTGRES_PORT;
    };

  serverEnv =
    {
      inherit (import "${pkgs.rootProjectDir}/config/public/database.nix")
        DATABASE_OWNER
        DATABASE_NAME;

      inherit (import "${pkgs.rootProjectDir}/config/ignored/passwords.nix")
        DATABASE_OWNER_PASSWORD;

      inherit (config)
        POSTGRES_HOST
        POSTGRES_PORT;
    };
}

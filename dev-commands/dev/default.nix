{ pkgs, config }:

# with config;

let
  lib = import ./lib.nix { inherit pkgs; };
in

config.mkScripts {
  dev__cat = ''
    arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      cat
  '';

  dev__down = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      down
  '';

  dev__up_detach = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      up --detach
  '';

  dev__db_tests = config.mkCommand
    {
      inherit (import "${pkgs.rootProjectDir}/config/public/database.nix")
        POSTGRES_USER
        DATABASE_NAME;

      inherit (import "${pkgs.rootProjectDir}/config/ignored/passwords.nix")
        POSTGRES_PASSWORD;

      inherit (lib.config)
        POSTGRES_HOST
        POSTGRES_PORT;
    }
    ''
      waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

      PGPASSWORD=$POSTGRES_PASSWORD \
        DB_TESTS_PREPARE_ARGS="--quiet -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE_NAME -U $POSTGRES_USER" \
        db-tests-prepare ./packages/db-tests/extensions

      PGPASSWORD=$POSTGRES_PASSWORD \
        pg_prove -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE_NAME -U $POSTGRES_USER --recurse --ext .sql ./packages/db-tests/tests/
    '';

  dev__db__dump_schema = config.mkCommand lib.migratorEnv ''
    DATABASE_URL=postgres://$DATABASE_OWNER:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME \
      dump-schema
  '';

  dev__db__migrate = config.mkCommand lib.migratorEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    wait-for-postgres --dbname=postgres://$DATABASE_OWNER:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME

    # for relative imports using \include command (shimg is using psql internally)
    cd ./migrations

    shmig -t postgresql \
      -m ./ \
      -C always \
      -l $DATABASE_OWNER \
      -p $DATABASE_OWNER_PASSWORD \
      -H $POSTGRES_HOST \
      -P $POSTGRES_PORT \
      -d $DATABASE_NAME \
      migrate
  '';

  dev__server = config.mkCommand lib.serverEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    wait-for-postgres --dbname=postgres://$DATABASE_OWNER:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME

    mkdir -p ./schemas

    GRAPHILE_LICENSE="${pkgs.lib.fileContents "${pkgs.rootProjectDir}/config/ignored/graphile-license"}" \
    sessionSecret="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").SESSION_SECRET}" \
    databaseOwnerPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_OWNER_PASSWORD}" \
    databaseAuthenticatorPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_AUTHENTICATOR_PASSWORD}" \
    oauthGithubClientSecret="${(import "${pkgs.rootProjectDir}/config/ignored/github-oauth.nix").CLIENT_SECRET}" \
      spago --config spago-api-server.dhall run --main ApiServer.Main --node-args '\
        --export-gql-schema-path "${pkgs.rootProjectDir}/schemas/schema.graphql" \
        --export-json-schema-path "${pkgs.rootProjectDir}/schemas/schema.json" \
        --port 3000 \
        --client-port 3001 \
        --hostname localhost \
        --rootUrl "http://localhost:3000" \
        --database-name "${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_NAME}" \
        --database-hostname "$POSTGRES_HOST" \
        --database-port "$POSTGRES_PORT" \
        --database-owner-user "${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_OWNER}" \
        --database-authenticator-user "${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_AUTHENTICATOR}" \
        --database-visitor-user "${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_VISITOR}" \
        --oauth-github-client-id "${(import "${pkgs.rootProjectDir}/config/ignored/github-oauth.nix").CLIENT_ID}" \
      '
  '';

  dev__db__drop = ''
    docker-volume-rm-if-exists nextjsdemo_import_postgres_data
  '';

  dev__feature_tests__run_chromedriver = ''
    chromedriver --verbose --port=9515
  '';

  dev__feature_tests__run = config.mkCommand lib.serverEnv ''
    remoteDownloadDirPath="${pkgs.rootProjectDir}/.feature-tests/remoteDownloadDir"
    chromeUserDataDirPath="${pkgs.rootProjectDir}/.feature-tests/chromeUserDataDir"

    mkdir -p "$remoteDownloadDirPath"
    mkdir -p "$chromeUserDataDirPath"

    databaseName="${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_NAME}" \
    databaseHost="$POSTGRES_HOST" \
    databasePort="$POSTGRES_PORT" \
    databaseOwnerUser="${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_OWNER}" \
    databaseOwnerPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_OWNER_PASSWORD}" \
    clientRootUrl="http://localhost" \
    chromedriverUrl="http://localhost:9515" \
    chromeBinaryPath="${pkgs.chromium}/bin/chromium" \
    remoteDownloadDirPath="$remoteDownloadDirPath" \
    chromeUserDataDirPath="$chromeUserDataDirPath" \
      exec spago --config spago-feature-tests.dhall run --main FeatureTests.Main
  '';
}

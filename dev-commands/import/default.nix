{ pkgs, config }:

with config;
with (import ./lib.nix { inherit pkgs; });

mkScripts {
  import__cat = ''
    arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      cat
  '';

  import__down = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      down
  '';

  import__up_detach = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      up --detach
  '';

  import__db_tests = mkCommand migratorEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    PGPASSWORD=$DATABASE_OWNER_PASSWORD \
      DB_TESTS_PREPARE_ARGS="--quiet -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE_NAME -U $DATABASE_OWNER" \
      db-tests-prepare ./db_tests/extensions

    PGPASSWORD=$DATABASE_OWNER_PASSWORD \
      pg_prove -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE_NAME -U $DATABASE_OWNER --recurse --ext .sql ./db_tests/tests/
  '';

  import__db__migrate = mkCommand migratorEnv ''
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

  import__server = mkCommand serverEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    wait-for-postgres --dbname=postgres://$DATABASE_OWNER:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME

    mkdir -p ./schemas

    spago run --main ApiServer.Main \
      --export-gql-schema-path "${pkgs.rootProjectDir}/schemas/schema.graphql" \
      --export-json-schema-path "${pkgs.rootProjectDir}/schemas/schema.json" \
      --port 3000 \
      --hostname localhost \
      --rootUrl "http://localhost:3000" \
      --database-name "$DATABASE_NAME" \
      --database-hostname "$POSTGRES_HOST" \
      --database-port "$POSTGRES_PORT" \
      --database-owner-user NAME \
      --database-authenticator-user NAME \
      --oauth-github-client-id "(import "${pkgs.rootProjectDir}/config/ignored/github-oauth.nix").CLIENT_ID"
  '';

  import__purescript-graphql-client-generator = ''
    purescript-graphql-client-generator --input-json ./schemas/schema.json --output app/Api --api Api
  '';

  import__db__drop = ''
    docker-volume-rm-if-exists nextjsdemo_import_postgres_data
  '';
}

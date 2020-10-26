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
    PGPASSWORD=$POSTGRES_PASSWORD db-tests-prepare ./db_tests/extensions
    PGPASSWORD=$POSTGRES_PASSWORD pg_prove -h $POSTGRES_HOST -p $POSTGRES_PORT -d $POSTGRES_DB -U $POSTGRES_USER --recurse --ext .sql ./db_tests/tests/
  '';

  import__db__migrate = mkCommand migratorEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30
    wait-for-postgres --dbname=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB

    # for relative imports using \include command (shimg is using psql internally)
    cd ./migrations

    shmig -t postgresql \
      -m ./ \
      -C always \
      -l $POSTGRES_USER \
      -p $POSTGRES_PASSWORD \
      -H $POSTGRES_HOST \
      -P $POSTGRES_PORT \
      -d $POSTGRES_DB \
      migrate
  '';

  import__server = mkCommand serverEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30
    wait-for-postgres --dbname=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB

    mkdir -p ./schemas

    spago run --main ApiServer.Main
  '';

  import__purescript-graphql-client-generator = ''
    purescript-graphql-client-generator --input-json ./schemas/schema.json --output app/Api --api Api
  '';

  import__db__drop = ''
    docker-volume-rm-if-exists nextjsdemo_import_postgres_data
  '';
}

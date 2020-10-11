{ pkgs, config }:

with config;

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

  import__up = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      up
  '';

  import__db_tests = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      run --rm db_tests sh -eux -c '\
        waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30 && \
        db-tests-prepare /db_tests/extensions && \
        pg_prove -h $POSTGRES_HOST -p $POSTGRES_PORT -d $POSTGRES_DB -U $POSTGRES_USER --recurse --ext .sql /db_tests/tests/ \
      '
  '';

  import__db__migrate = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      run --rm migrator sh -eux -c '\
      waitforit -host=$HOST -port=$PORT -timeout=30 && \
      wait-for-postgres --dbname=postgres://$LOGIN:$PASSWORD@$HOST:$PORT/$DATABASE && \
      shmig -t postgresql -m /migrations -C always migrate'
  '';

  import__db__drop = ''
    docker-volume-rm-if-exists nextjsdemo_import_postgres_data
  '';
}

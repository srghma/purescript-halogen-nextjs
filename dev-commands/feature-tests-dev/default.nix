{ pkgs, config }@args:

with config;

with (import ./lib.nix args);

mkScripts {
  feature_tests_dev__deps__cat = ''
    ${rootEnv}

    arion \
      --file docker/feature_tests_dev.nix \
      --pkgs nix/pkgs.nix \
      cat
  '';

  feature_tests_dev__deps__up = ''
    ${rootEnv}

    arion \
      --file docker/feature_tests_dev.nix \
      --pkgs nix/pkgs.nix \
      -p "nextjsdemo_import_feature_tests_dev" \
      up
  '';

  feature_tests_dev__deps__run = ''
    ${rootEnv}

    arion \
      --file docker/feature_tests_dev.nix \
      --pkgs nix/pkgs.nix \
      -p "nextjsdemo_import_feature_tests_dev" \
      run --service-ports --rm feature_tests
  '';

  feature_tests_dev__deps__run_sh = ''
    ${rootEnv}

    arion \
      --file docker/feature_tests_dev.nix \
      --pkgs nix/pkgs.nix \
      -p "nextjsdemo_import_feature_tests_dev" \
      run --service-ports --rm feature_tests \
      sh
  '';

  ###################
  ## db

  feature_tests_dev__db__migrate = ''
    ${migratorEnv}

    waitforit -host=$HOST -port=$PORT -timeout=30 && \
    wait-for-postgres --dbname=postgres://$LOGIN:$PASSWORD@$HOST:$PORT/$DATABASE && \
    shmig -m ./ -C always migrate
  '';

  feature_tests_dev__db__drop = ''
    docker-volume-rm-if-exists nextjsdemo_feature_tests_dev_postgres_data
  '';

  ###################
  ## rabbitmq

  feature_tests_dev__rabbitmq__drop = ''
    docker-volume-rm-if-exists nextjsdemo_feature_tests_dev_rabbitmq_data
  '';

  ###################
  ## server

  feature_tests_dev__server__run = ''
    ${serverEnv}

    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    exec yarn run start $@
  '';

  ###################
  ## client

  feature_tests_dev__client__run = ''
    ${clientEnv}

    waitforit -host=$SERVER_HOST -port=$SERVER_PORT -timeout=30

    exec yarn run dev $@
  '';

  ###################
  ## feature-tests

  feature_tests_dev__feature_tests__run = ''
    ${featureTestsEnv}

    waitforit -host=$SERVER_HOST -port=$SERVER_PORT -timeout=30
    waitforit -host=$CLIENT_HOST -port=$CLIENT_PORT -timeout=30
    waitforit -host=$MAILHOG_HOST -port=$MAILHOG_PORT -timeout=30
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=20
    # (curl --silent --fail --connect-timeout 40 $CLIENT_URL > /dev/null)

    exec yarn run test $@
  '';

  feature_tests_dev__feature_tests__interactive = ''
    ${featureTestsEnv}

    # waitforit -host=$CLIENT_HOST -port=$CLIENT_PORT -timeout=30
    # waitforit -host=$MAILHOG_HOST -port=$MAILHOG_PORT -timeout=30
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=20
    # (curl --silent --fail --connect-timeout 40 $CLIENT_URL > /dev/null)

    spago repl
  '';
}

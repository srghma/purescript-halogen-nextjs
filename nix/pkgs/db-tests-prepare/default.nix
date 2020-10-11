{ stdenv, lib, makeWrapper, postgresql, pgtap, coreutils, findutils, pgtest, runCommand }:

# idea stolen from https://github.com/walm/docker-pgtap/blob/master/test.sh

# TODO: raise error if PGPASSWORD not set
# TODO: raise error if $1 is not a directory

let
  text = ''
    #!${stdenv.shell}

    set -euxo pipefail

    PG_ARGS="--quiet -h $POSTGRES_HOST -p $POSTGRES_PORT -d $POSTGRES_DB -U $POSTGRES_USER"

    psql $PG_ARGS -f ${pgtap}/share/postgresql/extension/pgtap--1.1.0.sql

    psql $PG_ARGS -f $1/find_missing_indexes_on_foreign_keys.sql
    psql $PG_ARGS -f $1/has_column.sql
    psql $PG_ARGS -f $1/random_between.sql
    psql $PG_ARGS -f $1/random_boolean.sql
    psql $PG_ARGS -f $1/random_email.sql
    psql $PG_ARGS -f $1/random_enum.sql
    psql $PG_ARGS -f $1/random_string.sql

    psql $PG_ARGS -f ${pgtest}/pgtest.sql

    psql $PG_ARGS -f $1/allow_app_roles_execute_pgtap_functions.sql
  '';

  name = "db-tests-prepare";
in

runCommand name
  { inherit text;

    passAsFile = [ "text" ];

    nativeBuildInputs = [ makeWrapper ];

    # Pointless to do this on a remote machine.
    preferLocalBuild = true;
    allowSubstitutes = false;
  }
  ''
    mkdir -p $out/bin

    cp $textPath $out/bin/${name}

    chmod +x $out/bin/${name}

    wrapProgram $out/bin/${name} --prefix PATH : ${lib.makeBinPath [ postgresql coreutils ]}

    # check phase
    ${stdenv.shell} -n $out/bin/${name}
  ''

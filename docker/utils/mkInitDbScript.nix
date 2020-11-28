# from https://github.com/graphile/bootstrap-react-apollo/blob/70d33aa436a20dc791130c03cd96297036570919/scripts/setup#L139
{ pkgs }:
{ isProduction
, app_owner
, DATABASE_OWNER_PASSWORD

, app_anonymous
, DATABASE_ANONYMOUS_PASSWORD

, app_user

, DATABASE_NAME
}:
let
  maybeSuperuser = if isProduction then "" else "SUPERUSER";
in pkgs.writeTextFile {
  name = "init";

  text = ''
    #!/bin/bash
    set -e

    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        -- Now to set up the database cleanly:
        -- Ref: https://devcenter.heroku.com/articles/heroku-postgresql#connection-permissions

        -- This is the root role for the database
        -- IMPORTANT: don't grant SUPERUSER in production, we only need this so we can load the watch fixtures!
        CREATE ROLE app_owner WITH LOGIN PASSWORD '${DATABASE_OWNER_PASSWORD}' ${maybeSuperuser};

        -- This is the no-access role that PostGraphile will run as by default
        CREATE ROLE app_anonymous WITH LOGIN PASSWORD '${DATABASE_ANONYMOUS_PASSWORD}' NOINHERIT;

        -- This is the role that PostGraphile will switch to (from app_anonymous) during a GraphQL request
        CREATE ROLE app_user;

        -- This enables PostGraphile to switch from app_anonymous to app_user
        GRANT app_user TO app_anonymous;

        -- Here's our main database
        CREATE DATABASE ${DATABASE_NAME} OWNER app_owner;
        -- REVOKE ALL ON DATABASE ${DATABASE_NAME} FROM public;
        GRANT CONNECT ON DATABASE ${DATABASE_NAME} TO app_owner;
        GRANT CONNECT ON DATABASE ${DATABASE_NAME} TO app_anonymous;
        GRANT ALL ON DATABASE ${DATABASE_NAME} TO app_owner;

        -- Some extensions require superuser privileges, so we create them before migration time.
        \\connect ${DATABASE_NAME}
        CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
        CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
        CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    EOSQL
  '';
}



-- Sanity checks -----------------------------------------
alter default privileges revoke execute on functions from public;

create extension if not exists "pgcrypto";
create extension if not exists "citext";
create extension if not exists "uuid-ossp";

grant execute on function uuid_generate_v4() to public;

-- Create schemas

create schema app_public; -- tables and functions to be exposed to graphql
create schema app_hidden; -- same privileges as app_public, but simply not exposed to graphql
create schema app_private; -- secrets that require elevated privileges to access

-- Roles and schema grants -------------------------------------------------------

create role app_anonymous;
create role app_user;

grant usage on schema app_public to app_anonymous, app_user;
grant usage on schema app_hidden to app_anonymous, app_user;
grant usage on schema app_private to app_user;

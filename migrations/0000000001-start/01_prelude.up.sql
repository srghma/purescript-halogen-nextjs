-- Create schemas

create schema app_public; -- tables and functions to be exposed to graphql
create schema app_hidden; -- same privileges as app_public, but simply not exposed to graphql
create schema app_private; -- secrets that require elevated privileges to access

-- Roles and schema grants -------------------------------------------------------

grant usage on schema app_public to app_anonymous, app_user;
grant usage on schema app_hidden to app_anonymous, app_user;
grant usage on schema app_private to app_user;

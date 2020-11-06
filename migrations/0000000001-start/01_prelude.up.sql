-- tables and functions to be exposed to graphql
create schema app_public;
grant usage on schema app_public to app_visitor;
alter default privileges in schema app_public grant usage, select on sequences to app_visitor;

-- same privileges as app_public, but simply not exposed to graphql
create schema app_hidden;
grant usage on schema app_hidden to app_visitor;
alter default privileges in schema app_hidden grant usage, select on sequences to app_visitor;

-- secrets that require elevated privileges to access
create schema app_private;

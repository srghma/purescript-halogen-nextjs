create table app_public.users (
  id                             uuid         primary key default uuid_generate_v4(),
  first_name                     varchar(255) not null,
  last_name                      varchar(255) not null,
  email                          citext       not null unique check (email ~ '[^@]+@[^@]+\.[^@]+'),
  avatar_url                     text         check(avatar_url ~ '^https?://[^/]+'),
  password_hash                  text,

  -- TODO:
  -- make is_confirmed computable column?
  -- function users__is_confirmed(user) { return user.confirmation_token == null }
  is_confirmed                   boolean      not null default false,
  confirmation_token             text         unique,

  reset_password_token           text         unique,
  reset_password_token_generated timestamptz,

  created_at                     timestamptz  not null default now(),
  updated_at                     timestamptz  not null default now()
);

-- By doing `@omit all` we prevent the `allUsers` field from appearing in our
-- GraphQL schema.  User discovery is still possible by browsing the rest of
-- the data, but it makes it harder for people to receive a `totalCount` of
-- users, or enumerate them fully.
comment on table app_public.users is
  '@omit all
A user who can log in to the application.';

comment on column app_public.users.is_confirmed is
  '@omit create,update,delete';

comment on column app_public.users.password_hash is
  '@omit';

comment on column app_public.users.confirmation_token is
  '@omit';

comment on column app_public.users.reset_password_token is
  '@omit';

comment on column app_public.users.reset_password_token_generated is
  '@omit';

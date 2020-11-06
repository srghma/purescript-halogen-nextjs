create table app_public.users (
  id uuid not null primary key default uuid_generate_v4(),
  username citext not null unique check(length(username) >= 2 and length(username) <= 24 and username ~ '^[a-zA-Z]([a-zA-Z0-9][_]?)+$'),
  name text check(name <> ''),
  avatar_url text check(avatar_url ~ '^https?://[^/]+'),
  is_admin boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table app_public.users enable row level security;

create policy select_all on app_public.users for select using (true);
create policy update_self on app_public.users for update using (id = app_public.current_user_id_or_null());
create policy delete_self on app_public.users for delete using (id = app_public.current_user_id_or_null());

grant select on app_public.users to app_visitor;
-- NOTE: `insert` is not granted, because we'll handle that separately
grant update(name, avatar_url) on app_public.users to app_visitor;
grant delete on app_public.users to app_visitor;

-- By doing `@omit all` we prevent the `allUsers` field from appearing in our
-- GraphQL schema.  User discovery is still possible by browsing the rest of
-- the data, but it makes it harder for people to receive a `totalCount` of
-- users, or enumerate them fully.
comment on table app_public.users is
  E'@omit all\nA user who can log in to the application.';

comment on column app_public.users.id is
  E'Unique identifier for the user.';
comment on column app_public.users.username is
  E'Public-facing username (or ''handle'') of the user.';
comment on column app_public.users.name is
  E'Public-facing name (or pseudonym) of the user.';
comment on column app_public.users.avatar_url is
  E'Optional avatar URL.';
comment on column app_public.users.is_admin is
  E'If true, the user has elevated privileges.';

create trigger _100_timestamps
  before update on app_public.users
  for each row
  execute function app_private.tg__set_updated_at();

create function app_private.tg_users__make_first_user_admin() returns trigger as $$
begin
  if not exists(select 1 from app_public.users limit 1) then
    NEW.is_admin = true;
  end if;
  return NEW;
end;
$$ language plpgsql volatile set search_path from current;

create trigger _200_make_first_user_admin
  before insert on app_public.users
  for each row
  execute function app_private.tg_users__make_first_user_admin();

create table app_public.user_oauths (
  id                 uuid         primary key default uuid_generate_v4(),

  user_id            uuid
    not null
    references app_public.users
    on update cascade  -- if app_public.users.id is changed -  change also app_public.user_oauths,user_id
    on delete cascade, -- if app_public.users is deleted - delete also app_public.user_oauths,user_id,

  service            citext       not null,
  service_identifier varchar(255) not null,
  created_at         timestamptz  not null default now(),
  updated_at         timestamptz  not null default now(),

  constraint uniq_user_oauths unique(service, service_identifier)
);

create index app_public_user_oauths_user_id on app_public.user_oauths (user_id);

comment on table app_public.user_oauths is
  '@omit all
Contains information about the login providers this user has used, so that they may disconnect them should they wish.';

comment on column app_public.user_oauths.user_id is
  '@omit';
comment on column app_public.user_oauths.service is
  'The login service used, e.g. `twitter` or `github`.';
comment on column app_public.user_oauths.service_identifier is
  'A unique identifier for the user within the login service.';

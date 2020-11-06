

\set role     $$'app_user'$$
\set user_id  $$'00000000-0000-0000-0000-000000000001'$$
\set email    $$'user@mail.com'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

select
  encode(gen_random_bytes(4), 'hex') as token
into temporary table myvars;
grant select on table myvars to app_visitor, app_user;

insert into app_public.users
  (
    id,
    email,
    first_name,
    last_name,
    is_confirmed,
    confirmation_token
  )
  values
  (
    :user_id,
    :email,
    random_string(),
    random_string(),
    false,
    (select token from myvars limit 1)
  );

set local role :role;
select is(current_user, :role);

prepare do_things as
  select
    app_public.confirm(
      'invlid_token'
    );

select throws_ok(
  'do_things',
  'APP_EXCEPTION__CONFIRM__TOKEN_IS_INVALID_OR_YOU_ARE_ALREADY_CONFIRMED'
);

-- Check user wasn't changed
select
  is(is_confirmed, false)
from app_public.users;

select
  is(confirmation_token, (select token from myvars limit 1)::text)
from app_public.users;

select finish();

rollback;

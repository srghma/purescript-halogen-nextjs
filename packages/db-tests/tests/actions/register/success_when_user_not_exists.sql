
\set role $$'app_user'$$

\set first_name $$'user1_first_name'$$
\set last_name  $$'user1_first_name'$$

\set email    $$'user@mail.com'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

prepare do_things as
  select * from app_public.register(
    :first_name,
    :last_name,
    :email,
    :password
  );

select set_eq(
  'do_things',
  '(select * from app_public.users order by created_at desc limit 1)'
);

select
  is(is_confirmed, false)
from app_public.users order by created_at desc limit 1;

select
  isnt(confirmation_token, null)
from app_public.users order by created_at desc limit 1;

select finish();

rollback;

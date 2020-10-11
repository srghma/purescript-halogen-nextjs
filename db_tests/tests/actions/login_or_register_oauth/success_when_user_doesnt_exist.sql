
\set service            $$'facebook'$$
\set service_identifier $$'0000000000000000'$$
\set email              $$'user@mail.com'$$
\set new_first_name     $$'new_first_name'$$
\set new_last_name      $$'new_last_name'$$
\set avatar_url         $$'http://asfdasdf.com/asdf'$$

begin;

select no_plan();

select set_eq('select count(*) from app_public.users', array[0]);
select set_eq('select count(*) from app_public.user_oauths', array[0]);

prepare actual as
  select app_private.login_or_register_oauth(
    :service,
    :service_identifier,
    :email,
    :new_first_name,
    :new_last_name,
    :avatar_url
  );

prepare expected as values
  (
    (
      'app_user',
      (select id from app_public.users order by created_at desc limit 1)
    )::app_public.jwt
  );

select set_eq(
  'actual',
  'expected'
);

select set_eq('select count(*) from app_public.users', array[1]);
select set_eq('select count(*) from app_public.user_oauths', array[1]);

select set_eq('select first_name from app_public.users', array[:new_first_name]);
select set_eq('select last_name from app_public.users',  array[:new_last_name]);

select finish();

rollback;

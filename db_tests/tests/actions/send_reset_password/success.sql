

\set role     $$'app_user'$$
\set user_id  $$'00000000-0000-0000-0000-000000000001'$$
\set email    $$'user@mail.com'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name, is_confirmed, password_hash)
  values
  (:user_id, :email, random_string(), random_string(), true, crypt(:password, gen_salt('bf')));

-- Spy on function

select pgtest.spy('app_private', 'rabbitmq__send_reset_password_mail', ARRAY['app_public.users']);

-- Spy END

-- Test body
set local role :role;
select is(current_user, :role);

prepare do_stuff as
  select app_public.send_reset_password(:email);

select lives_ok('do_stuff');

-- Test body END

-- Check function has been called

set local role 'app_admin';

select pgtest.assert_called(pgtest.get_mock_id('app_private', 'rabbitmq__send_reset_password_mail', ARRAY['app_public.users']), 1);

select finish();

rollback;

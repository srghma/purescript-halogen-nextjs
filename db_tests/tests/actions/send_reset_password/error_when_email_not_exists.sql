

\set role     $$'app_user'$$
\set user_id  $$'00000000-0000-0000-0000-000000000001'$$
\set email    $$'user@mail.com'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

select pgtest.spy('app_private', 'rabbitmq__send_reset_password_mail', ARRAY['app_public.users']);

-- Test body
set local role :role;
select is(current_user, :role);

prepare do_stuff as
  select app_public.send_reset_password(:email);

select throws_ok(
  'do_stuff',
  'email not registered'
);

-- Test body END

-- Check app_private.rabbitmq__send_reset_password has not been called

set local role 'app_admin';

select pgtest.assert_called(pgtest.get_mock_id('app_private', 'rabbitmq__send_reset_password_mail', ARRAY['app_public.users']), 0);

select finish();

rollback;

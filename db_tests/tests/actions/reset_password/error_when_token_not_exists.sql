

\set role         $$'app_user'$$
\set user_id      $$'00000000-0000-0000-0000-000000000001'$$
\set email        $$'user@mail.com'$$
\set password     $$'secret_pass'$$
\set token        $$'some-token'$$
\set new_password $$'new_secret_pass'$$

begin;

select no_plan();

select pgtest.spy('app_private', 'rabbitmq__send_password_was_changed_mail', ARRAY['app_public.users']);

-- Test body
set local role :role;
select is(current_user, :role);

prepare do_stuff as
  select app_public.reset_password(:token, :new_password);

select throws_ok(
  'do_stuff',
  'APP__EXCEPTION__RESET_PASSWORD__TOKEN_IS_INVALID'
);

-- Test body END

-- Check app_private.rabbitmq__reset_password has not been called

set local role 'app_admin';

select pgtest.assert_called(pgtest.get_mock_id('app_private', 'rabbitmq__send_password_was_changed_mail', ARRAY['app_public.users']), 0);

select finish();

rollback;

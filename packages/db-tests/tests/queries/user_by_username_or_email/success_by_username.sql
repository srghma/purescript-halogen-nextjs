\set role     $$'app_visitor'$$
\set user_id  $$'00000000-0000-0000-0000-000000000001'$$
\set email    $$'user@mail.com'$$
\set username $$'username2'$$

begin;

select no_plan();

select diag((id::text, username::text)), diag(username::text) from app_public.users;

INSERT INTO app_public.users (id, username)
  VALUES (:user_id, :username);

set local role :role;
select is(current_user, :role);

prepare actual as
  select id, username
  from app_public.user_by_username_or_email(:username);

prepare expected as values
  ((:user_id, :username));

select set_eq(
  'actual',
  'expected'
);

select finish();

rollback;

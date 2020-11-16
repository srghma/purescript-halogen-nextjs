

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

set local role :role;
select is(current_user, :role);

prepare actual as
  select app_public.login(:email, :password);

prepare expected as values
  (('app_user', :user_id)::app_public.jwt);

select set_eq(
  'actual',
  'expected'
);

select finish();

rollback;
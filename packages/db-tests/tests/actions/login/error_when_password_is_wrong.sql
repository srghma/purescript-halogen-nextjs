
\set role       $$'app_user'$$
\set user_id    $$'00000000-0000-0000-0000-000000000001'$$
\set email      $$'user@mail.com'$$
\set password   $$'secret_pass'$$
\set wrong_pass $$'wrong_pass'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name, is_confirmed, password_hash)
  values
  (:user_id, :email, random_string(), random_string(), true, crypt(:password, gen_salt('bf')));

set local role :role;
select is(current_user, :role);

prepare do_stuff as
  select app_public.login(:email, :wrong_pass);

select throws_ok(
  'do_stuff',
  'APP_EXCEPTION__LOGIN__WRONG_PASSWORD'
);

select finish();

rollback;

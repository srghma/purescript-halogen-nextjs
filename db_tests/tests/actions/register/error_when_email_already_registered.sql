
\set role $$'app_user'$$

\set first_name $$'user1_first_name'$$
\set last_name  $$'user1_first_name'$$

\set email    $$'user@mail.com'$$
\set password $$'secret_pass'$$

\set user_id $$'00000000-0000-0000-0000-000000000001'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name, is_confirmed)
  values
  (:user_id, :email, random_string(), random_string(), random_boolean());

prepare do_stuff as
  select id from app_public.register(
    :first_name,
    :last_name,
    :email,
    :password
  );

select throws_ok(
  'do_stuff',
  'email already registered'
);

select finish();

rollback;

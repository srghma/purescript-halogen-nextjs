\set role     $$'app_owner'$$
\set email    $$'user@mail.com'$$
\set username $$'username2'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

-- Spy

select pgtest.spy(
  'graphile_worker',
  'add_job',
  ARRAY['text', 'json', 'text', 'timestamp with time zone', 'integer', 'text', 'integer', 'text[]']::VARCHAR[]
);

-- Spy END

select graphile_worker.add_job(
  'sendVerificationEmailForUserEmail',
  json_build_object(
    'id', 1
  )::json
);

set local role :role;
select is(current_user, :role);

/* prepare actual as */
/*   select username from app_private.really_create_user( */
/*     username          => :username, */
/*     email             => :email, */
/*     email_is_verified => false, */
/*     name              => null, */
/*     avatar_url        => null, */
/*     password          => :password */
/*   ); */

/* prepare expected as values */
/*   (:username); */

/* select set_eq( */
/*   'actual', */
/*   'expected' */
/* ); */

-- Test body END

-- Check function has been called

set local role 'app_admin';

/* select pgtest.assert_called( */
/*   pgtest.get_mock_id( */
/*     'graphile_worker', */
/*     'add_job', */
/*     ARRAY['text', 'json', 'text', 'timestamp with time zone', 'integer', 'text', 'integer', 'text[]'] */
/*   ), */
/*   1 */
/* ); */

select finish();

rollback;

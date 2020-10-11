
\set schema $$'app_public'$$
\set func $$'reset_password'$$
\set args $$'{"text","text"}'$$::text[]

begin;

select no_plan();

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_admin',
  '{"EXECUTE"}'
);

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_anonymous',
  '{"EXECUTE"}'
);

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_user',
  '{"EXECUTE"}'
);

select finish();

rollback;

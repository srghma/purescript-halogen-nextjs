\set schema $$'app_public'$$
\set func $$'user_by_username_or_email'$$
\set args $$'{text}'$$::text[]

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
  'app_visitor',
  '{"EXECUTE"}'
);

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_owner',
  '{"EXECUTE"}'
);

select finish();

rollback;

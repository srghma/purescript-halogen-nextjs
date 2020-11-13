
\set schema $$'app_public'$$

begin;

select no_plan();

select tables_are(
  :schema,
  array[
    'users',
    'user_oauths',
    'posts'
  ]::text[]
);

select types_are(:schema, array[
  'jwt'
]::text[]);

select domains_are(:schema, array[]::text[]);

select enums_are(
  :schema,
  array[]::text[]
);

select functions_are(
  :schema,
  array[
    'login',
    'current_user',
    'current_user',
    'current_user_id_required',
    'current_user_id_or_null',
    'users_full_name',
    'register',
    'confirm',
    'resend_confirmation',
    'reset_password',
    'send_reset_password',
    'next_users_confirmation_token',
    'next_users_reset_password_token',
    'generate_url_safe_token'
  ]::text[]
);

select views_are(
  :schema,
  array[]::text[]
);

select materialized_views_are(
  :schema,
  array[]::text[]
);

select finish();

rollback;


\set schema $$'app_private'$$

begin;

select no_plan();

select tables_are(
  :schema,
  array[]::text[]
);

select types_are(:schema, array[]::text[]);

select domains_are(:schema, array[]::text[]);

select enums_are( :schema, array[]::text[]);

select functions_are(
  :schema,
  array[
    'tg__set_updated_at',
    'rabbitmq__send_confirmation_mail',
    'rabbitmq__send_welcome_mail',
    'rabbitmq__send_reset_password_mail',
    'rabbitmq__send_password_was_changed_mail',
    'login_or_register_oauth'
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

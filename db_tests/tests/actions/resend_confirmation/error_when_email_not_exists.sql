

\set role     $$'app_user'$$
\set user_id  $$'00000000-0000-0000-0000-000000000001'$$
\set email    $$'user@mail.com'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

-- Spy on function

create temp table rabbitmq__send_confirmation_mail__calls(
  arguments json
);

grant select on table rabbitmq__send_confirmation_mail__calls to app_anonymous, app_user;

create or replace function app_private.rabbitmq__send_confirmation_mail(a_user app_public.users) returns void as $$
begin
  insert into rabbitmq__send_confirmation_mail__calls (arguments) values (row_to_json($1));
end;
$$ language plpgsql volatile set search_path from current;

-- Spy on function END

-- Test body
set local role :role;
select is(current_user, :role);

prepare do_stuff as
  select app_public.resend_confirmation(:email);

select throws_ok(
  'do_stuff',
  'APP__EXCEPTION__RESEND_CONFIRMATION__NOT_REGISTERED'
);

-- Test body END

-- Check function hasn't been called

set local role 'app_admin';

select
  is(count(*), 0::bigint)
from rabbitmq__send_confirmation_mail__calls;

select finish();

rollback;

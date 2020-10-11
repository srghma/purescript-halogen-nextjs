/*
This source code may reproduce and may modify the following components:

Name: 400_users.sql
Link to file: https://github.com/graphile/examples/blob/7951e87a772d7e5e601f42545769a7cc55aa7ad7/db/400_users.sql#L254-L272
Copyright: Copyright © 2018 Benjie Gillam
Licence: MIT (https://github.com/graphile/examples/blob/7951e87a77/LICENSE.md)
*/

/*
TODO:
  1. populate confirmation_token if it's empty

     OR

     make is_confirmed property calculated from confirmation_token
     (confirmation_token is null - is_confirmed is true,
     confirmation_token is not null - is_confirmed is false)

  2. refresh confirmation_token each '3 days'
     v_reset_max_duration interval = interval '3 days';
     https://github.com/graphile/examples/blob/7951e87a772d7e5e601f42545769a7cc55aa7ad7/db/400_users.sql#L254-L272

  3. prevent spamming
     v_reset_min_duration_between_emails interval = interval '30 minutes';
*/

create function app_public.resend_confirmation(
  email text
) returns void as $$
declare
  v_user app_public.users;
begin
  select x.* into v_user
    from app_public.users as x
    where x.email = resend_confirmation.email;

  if v_user is null then
    raise exception 'email not registered';
  end if;

  if v_user.is_confirmed = true then
    raise exception 'already confirmed';
  end if;

  -- Send confirmation email
  perform app_private.rabbitmq__send_confirmation_mail(v_user);

  return;
end;
$$ language plpgsql
  strict
  security definer;

comment on function app_public.resend_confirmation(
  text
)
is 'Resends confirmation email if user exists and is not already confirmed';

grant execute on function app_public.resend_confirmation(
  text
) to app_anonymous, app_user;

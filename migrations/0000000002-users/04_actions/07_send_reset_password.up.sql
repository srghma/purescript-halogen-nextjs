/*
TODO:
  1. prevent spamming
     v_reset_min_duration_between_emails interval = interval '30 minutes';
*/

create function app_public.send_reset_password(
  email text
) returns void as $$
declare
  v_user app_public.users;

  -- inspired by https://github.com/graphile/examples/blob/7951e87a772d7e5e601f42545769a7cc55aa7ad7/db/400_users.sql#L254-L272
  v_reset_max_duration interval = interval '3 days';

  /* v_reset_min_duration_between_emails interval = interval '30 minutes'; */
begin
  select x.* into v_user
    from app_public.users as x
    where x.email = send_reset_password.email;

  if v_user is null then
    raise exception 'APP__EXCEPTION__SEND_RESET_PASSWORD__EMAIL_NOT_REGISTERED';
  end if;

  -- Only confirmed user can reset password
  if v_user.is_confirmed = false then
    raise exception 'APP__EXCEPTION__SEND_RESET_PASSWORD__EMAIL_NOT_CONFIRMED';
  end if;

  -- Fetch or generate reset token
  update app_public.users
    set
      reset_password_token = (
        case
        when reset_password_token is null or reset_password_token_generated < NOW() - v_reset_max_duration
        then app_public.next_users_reset_password_token()
        else reset_password_token
        end
      ),
      reset_password_token_generated = (
        case
        when reset_password_token is null or reset_password_token_generated < NOW() - v_reset_max_duration
        then now()
        else reset_password_token_generated
        end
      )
    where id = v_user.id
    returning * into v_user;

  -- Send reset password email
  perform app_private.rabbitmq__send_reset_password_mail(v_user);

  return;
end;
$$ language plpgsql
  strict
  security definer;

comment on function app_public.send_reset_password(
  text
)
is 'Resends reset password email if user exists and is confirmed';

grant execute on function app_public.send_reset_password(
  text
) to app_anonymous, app_user;

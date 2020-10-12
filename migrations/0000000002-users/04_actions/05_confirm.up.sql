create function app_public.confirm(
  token text
) returns app_public.jwt as $$
declare
  v_user app_public.users;
begin
  select x.* into v_user
    from app_public.users as x
    where x.is_confirmed = false
    and x.confirmation_token = confirm.token;

  if v_user is null then
    raise exception 'APP__EXCEPTION__CONFIRM__TOKEN_IS_INVALID_OR_YOU_ARE_ALREADY_CONFIRMED';
  end if;

  update app_public.users
    set
      is_confirmed = true,
      confirmation_token = null
    where id = v_user.id
    returning * into v_user;

  /*
  NOTE:
  how to set role after authorization, in order to not make second request?

  functions below throw error
  CANNOT SET PARAMETER "ROLE" WITHIN SECURITY-DEFINER FUNCTION

  perform set_config('role', 'app_user', true);
  perform set_config('jwt.claims.role', 'app_user', true);
  perform set_config('jwt.claims.user_id', v_user.id :: text, true);
  */

  /*
  TODO
  perform app_private.rabbitmq__send_welcome_mail(v_user);
  */

  return ('app_user', v_user.id)::app_public.jwt;
end;
$$ language plpgsql
  strict
  security definer;

comment on function app_public.confirm(
  text
)
is 'Sets is_confirmed = true if token is right';

grant execute on function app_public.confirm(
  text
) to app_anonymous, app_user;

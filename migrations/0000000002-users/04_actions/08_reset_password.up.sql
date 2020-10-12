create function app_public.reset_password(
  token text,
  new_password text
) returns app_public.jwt as $$
declare
  v_user app_public.users;
begin
  select x.* into v_user
    from app_public.users as x
    where x.reset_password_token = reset_password.token;

  if v_user is null then
    raise exception 'APP__EXCEPTION__RESET_PASSWORD__TOKEN_IS_INVALID';
  end if;

  -- Only confirmed user can reset password
  if v_user.is_confirmed = false then
    raise exception 'APP__EXCEPTION__RESET_PASSWORD__USER_NOT_CONFIRMED';
  end if;

  update app_public.users
    set
      reset_password_token = null,
      reset_password_token_generated = null,
      password_hash = crypt(new_password, gen_salt('bf'))
    where id = v_user.id
    returning * into v_user;

  perform app_private.rabbitmq__send_password_was_changed_mail(v_user);

  return ('app_user', v_user.id)::app_public.jwt;
end;
$$ language plpgsql
  strict
  security definer;

comment on function app_public.reset_password(
  text,
  text
)
is 'Changes password if reset password token is valid';

grant execute on function app_public.reset_password(
  text,
  text
) to app_anonymous, app_user;

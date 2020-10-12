create function app_public.login(
  email    text,
  password text
) returns app_public.jwt as $$
declare
  v_user app_public.users;
begin
  select x.* into v_user
  from app_public.users as x
  where x.email = login.email;

  if v_user is null then
    raise exception 'APP__EXCEPTION__LOGIN__EMAIL_NOT_REGISTERED';
  end if;

  if v_user.is_confirmed = false then
    raise exception 'APP__EXCEPTION__LOGIN__NOT_CONFIRMED';
  end if;

  if v_user.password_hash != crypt(login.password, v_user.password_hash) then
    raise exception 'APP__EXCEPTION__LOGIN__WRONG_PASSWORD';
  end if;

  return ('app_user', v_user.id)::app_public.jwt;
end;
$$ language plpgsql
  strict -- the function always returns null whenever any of its arguments are null
  security definer; -- function is to be executed with the privileges of the user that created it

comment on function app_public.login(
  text,
  text
) is 'Creates a jwt token that will securely identify a users and give them certain permissions.';

grant execute on function app_public.login(
  text,
  text
) to app_anonymous, app_user;

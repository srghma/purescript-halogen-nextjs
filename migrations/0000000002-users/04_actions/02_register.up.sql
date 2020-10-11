create function app_public.register(
  first_name text,
  last_name  text,
  email      text,
  password   text
) returns app_public.users as $$
declare
  v_user app_public.users;
begin
  select x.* into v_user
  from app_public.users as x
  where x.email = register.email;

  if v_user.id is not null then
    raise exception 'email already registered';
  end if;

  -- Insert the new user
  insert into app_public.users (
    email,
    first_name,
    last_name,
    password_hash,
    is_confirmed,
    confirmation_token
  ) values
    (
      email,
      first_name,
      last_name,
      crypt(password, gen_salt('bf')),
      false,
      app_public.next_users_confirmation_token() -- FIXME: use seq with encode to md5 https://stackoverflow.com/a/38846293/3574379
    )
    returning * into v_user;

  -- Send confirmation email
  perform app_private.rabbitmq__send_confirmation_mail(v_user);

  return v_user;
end;
$$ language plpgsql
  strict
  security definer;

comment on function app_public.register(
  first_name text,
  last_name  text,
  email      text,
  password   text
)
is 'Registers a single user and creates an account in our forum.';

grant execute on function app_public.register(
  text,
  text,
  text,
  text
) to app_anonymous, app_user;

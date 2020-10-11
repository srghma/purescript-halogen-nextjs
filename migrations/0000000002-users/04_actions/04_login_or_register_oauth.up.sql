create function app_private.login_or_register_oauth(
  service            text,
  service_identifier text,
  email              text,
  first_name         text,
  last_name          text,
  avatar_url         text
) returns app_public.jwt as $$
declare
  v_user       app_public.users;
  v_user_oauth app_public.user_oauths;
begin
  select users.* into v_user
  from app_public.users as users
  where users.email = login_or_register_oauth.email;

  if v_user is null then
    -- No user with that email was found
    -- Insert the new user
    insert into app_public.users (
      email,
      first_name,
      last_name,
      avatar_url,
      is_confirmed
    ) values
      (
        login_or_register_oauth.email,
        login_or_register_oauth.first_name,
        login_or_register_oauth.last_name,
        login_or_register_oauth.avatar_url,
        true
      )
      returning * into v_user;
  end if;

  -- TODO: if is_confirmed = false then update is_confirmed = true

  select user_oauths.* into v_user_oauth
  from app_public.user_oauths as user_oauths
  where user_oauths.service = login_or_register_oauth.service
  and user_oauths.service_identifier = login_or_register_oauth.service_identifier;

  if v_user_oauth is null then
    insert into app_public.user_oauths (
      user_id,
      service,
      service_identifier
    ) values
      (
        v_user.id,
        login_or_register_oauth.service,
        login_or_register_oauth.service_identifier
      );

    -- TODO: If User registered via oauth first time and not confirmed - send welcome email
    /* perform app_private.rabbitmq__send_welcome_mail(v_user); */
  end if;

  return ('app_user', v_user.id)::app_public.jwt;
end;
$$ language plpgsql volatile security definer set search_path from current;

comment on function app_private.login_or_register_oauth(
  text,
  text,
  text,
  text,
  text,
  text
) is
  'If you''re logged in, this will link an additional OAuth login to your account if necessary.'
  'If you''re logged out it may find if an account already exists (based on OAuth details or email address)'
  'and return that, or create a new user account if necessary.';

grant execute on function app_private.login_or_register_oauth(
  text,
  text,
  text,
  text,
  text,
  text
) to app_anonymous, app_user;

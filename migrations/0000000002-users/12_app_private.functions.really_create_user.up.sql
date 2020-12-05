create function app_private.really_create_user(
  username text,
  email text,
  email_is_verified bool,
  name text,
  avatar_url text,
  password text default null
) returns app_public.users as $$
declare
  v_user app_public.users;
  v_user_secret_id uuid;
  v_password text;
  v_username text = username;
begin
  -- Sanitise the username, and make it unique if necessary.
  if v_username is null then
    v_username = coalesce(name, 'user');
  end if;
  v_username = regexp_replace(v_username, '^[^a-z]+', '', 'i');
  v_username = regexp_replace(v_username, '[^a-z0-9]+', '_', 'i');
  if v_username is null or length(v_username) < 3 then
    v_username = 'user';
  end if;
  select (
    case
    when i = 0 then v_username
    else v_username || i::text
    end
  ) into v_username from generate_series(0, 1000) i
  where not exists(
    select 1
    from app_public.users
    where users.username = (
      case
      when i = 0 then v_username
      else v_username || i::text
      end
    )
  )
  limit 1;

  -- Store the password
  if password is null then
    v_password = null;
  else
    v_password = crypt(v_password, gen_salt('bf'));
  end if;

  insert into app_private.user_secrets (password_hash) values
    (v_password)
    returning id into v_user_secret_id;

  -- Insert the new user
  insert into app_public.users (user_secret_id, username, name, avatar_url) values
    (v_user_secret_id, v_username, name, avatar_url)
    returning * into v_user;

  -- Add the user's email
  if email is not null then
    insert into app_hidden.user_emails (user_id, email, is_verified)
    values (v_user.id, email, email_is_verified);
  end if;

  return v_user;
end;
$$ language plpgsql volatile set search_path from current;

comment on function app_private.really_create_user(username text, email text, email_is_verified bool, name text, avatar_url text, password text) is
  E'Creates a user account. All arguments are optional, it trusts the calling method to perform sanitisation.';

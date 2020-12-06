--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: app_hidden; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app_hidden;


--
-- Name: app_private; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app_private;


--
-- Name: app_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app_public;


--
-- Name: graphile_worker; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphile_worker;


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: biconditional_statement(boolean, boolean); Type: FUNCTION; Schema: app_hidden; Owner: -
--

CREATE FUNCTION app_hidden.biconditional_statement(a boolean, b boolean) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  select (a and b) or (not a and not b)
$$;


--
-- Name: implication(boolean, boolean); Type: FUNCTION; Schema: app_hidden; Owner: -
--

CREATE FUNCTION app_hidden.implication(a boolean, b boolean) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  select not a or b
$$;


--
-- Name: is_from_0_to_100(numeric); Type: FUNCTION; Schema: app_hidden; Owner: -
--

CREATE FUNCTION app_hidden.is_from_0_to_100(num numeric) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  select (num >= 0) AND (num <= 100);
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: users; Type: TABLE; Schema: app_public; Owner: -
--

CREATE TABLE app_public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_secret_id uuid NOT NULL,
    username public.citext NOT NULL,
    name text,
    avatar_url text,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_avatar_url_check CHECK ((avatar_url ~ '^https?://[^/]+'::text)),
    CONSTRAINT users_name_check CHECK ((name <> ''::text)),
    CONSTRAINT users_username_check CHECK (((length((username)::text) >= 2) AND (length((username)::text) <= 24) AND (username OPERATOR(public.~) '^[a-zA-Z]([a-zA-Z0-9][_]?)+$'::public.citext)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON TABLE app_public.users IS '@omit all
A user who can log in to the application.';


--
-- Name: COLUMN users.id; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.users.id IS 'Unique identifier for the user.';


--
-- Name: COLUMN users.username; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.users.username IS 'Public-facing username (or ''handle'') of the user.';


--
-- Name: COLUMN users.name; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.users.name IS 'Public-facing name (or pseudonym) of the user.';


--
-- Name: COLUMN users.avatar_url; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.users.avatar_url IS 'Optional avatar URL.';


--
-- Name: COLUMN users.is_admin; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.users.is_admin IS 'If true, the user has elevated privileges.';


--
-- Name: link_or_register_user(integer, character varying, character varying, json, json); Type: FUNCTION; Schema: app_private; Owner: -
--

CREATE FUNCTION app_private.link_or_register_user(f_user_id integer, f_service character varying, f_identifier character varying, f_profile json, f_auth_details json) RETURNS app_public.users
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO '$user', 'public'
    AS $$
declare
  v_matched_user_id uuid;
  v_matched_authentication_id int;
  v_email citext;
  v_name text;
  v_avatar_url text;
  v_user app_public.users;
  v_user_email app_hidden.user_emails;
begin
  -- See if a user account already matches these details
  select id, user_id
    into v_matched_authentication_id, v_matched_user_id
    from app_public.user_authentications
    where service = f_service
    and identifier = f_identifier
    limit 1;

  if v_matched_user_id is not null and f_user_id is not null and v_matched_user_id <> f_user_id then
    /* A different user already has this account linked. */
    raise exception 'APP_EXCEPTION__LINK_OR_REGISTER_USER__DIFFERENT_ACCOUNT_ALREADY_LINKED' using errcode='TAKEN';
  end if;

  v_email = f_profile ->> 'email';
  v_name := f_profile ->> 'name';
  v_avatar_url := f_profile ->> 'avatar_url';

  if v_matched_authentication_id is null then
    if f_user_id is not null then
      -- Link new account to logged in user account
      insert into app_public.user_authentications (user_id, service, identifier, details) values
        (f_user_id, f_service, f_identifier, f_profile) returning id, user_id into v_matched_authentication_id, v_matched_user_id;
      insert into app_private.user_authentication_secrets (user_authentication_id, details) values
        (v_matched_authentication_id, f_auth_details);
    elsif v_email is not null then
      -- See if the email is registered
      select * into v_user_email from app_hidden.user_emails where email = v_email and is_verified is true;
      if not (v_user_email is null) then
        -- User exists!
        insert into app_public.user_authentications (user_id, service, identifier, details) values
          (v_user_email.user_id, f_service, f_identifier, f_profile) returning id, user_id into v_matched_authentication_id, v_matched_user_id;
        insert into app_private.user_authentication_secrets (user_authentication_id, details) values
          (v_matched_authentication_id, f_auth_details);
      end if;
    end if;
  end if;
  if v_matched_user_id is null and f_user_id is null and v_matched_authentication_id is null then
    -- Create and return a new user account
    return app_private.register_user(f_service, f_identifier, f_profile, f_auth_details, true);
  else
    if v_matched_authentication_id is not null then
      update app_public.user_authentications
        set details = f_profile
        where id = v_matched_authentication_id;
      update app_private.user_authentication_secrets
        set details = f_auth_details
        where user_authentication_id = v_matched_authentication_id;
      update app_public.users
        set
          name = coalesce(users.name, v_name),
          avatar_url = coalesce(users.avatar_url, v_avatar_url)
        where id = v_matched_user_id
        returning  * into v_user;
      return v_user;
    else
      -- v_matched_authentication_id is null
      -- -> v_matched_user_id is null (they're paired)
      -- -> f_user_id is not null (because the if clause above)
      -- -> v_matched_authentication_id is not null (because of the separate if block above creating a user_authentications)
      -- -> contradiction.

      /* This should not occur */
      raise exception 'APP_EXCEPTION__RESET_PASSWORD__SHOULD_NOT_OCCUR';
    end if;
  end if;
end;
$$;


--
-- Name: FUNCTION link_or_register_user(f_user_id integer, f_service character varying, f_identifier character varying, f_profile json, f_auth_details json); Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON FUNCTION app_private.link_or_register_user(f_user_id integer, f_service character varying, f_identifier character varying, f_profile json, f_auth_details json) IS 'If you''re logged in, this will link an additional OAuth login to your account if necessary. If you''re logged out it may find if an account already exists (based on OAuth details or email address) and return that, or create a new user account if necessary.';


--
-- Name: really_create_user(text, text, boolean, text, text, text); Type: FUNCTION; Schema: app_private; Owner: -
--

CREATE FUNCTION app_private.really_create_user(username text, email text, email_is_verified boolean, name text, avatar_url text, password text DEFAULT NULL::text) RETURNS app_public.users
    LANGUAGE plpgsql
    SET search_path TO '$user', 'public'
    AS $$
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
$$;


--
-- Name: FUNCTION really_create_user(username text, email text, email_is_verified boolean, name text, avatar_url text, password text); Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON FUNCTION app_private.really_create_user(username text, email text, email_is_verified boolean, name text, avatar_url text, password text) IS 'Creates a user account. All arguments are optional, it trusts the calling method to perform sanitisation.';


--
-- Name: register_user(character varying, character varying, json, json, boolean); Type: FUNCTION; Schema: app_private; Owner: -
--

CREATE FUNCTION app_private.register_user(f_service character varying, f_identifier character varying, f_profile json, f_auth_details json, f_email_is_verified boolean DEFAULT false) RETURNS app_public.users
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO '$user', 'public'
    AS $$
declare
  v_user app_public.users;
  v_email citext;
  v_name text;
  v_username text;
  v_avatar_url text;
  v_user_authentication_id int;
begin
  -- Extract data from the user’s OAuth profile data.
  v_email := f_profile ->> 'email';
  v_name := f_profile ->> 'name';
  v_username := f_profile ->> 'username';
  v_avatar_url := f_profile ->> 'avatar_url';

  -- Create the user account
  v_user = app_private.really_create_user(
    username => v_username,
    email => v_email,
    email_is_verified => f_email_is_verified,
    name => v_name,
    avatar_url => v_avatar_url
  );

  -- Insert the user’s private account data (e.g. OAuth tokens)
  insert into app_public.user_authentications (user_id, service, identifier, details) values
    (v_user.id, f_service, f_identifier, f_profile) returning id into v_user_authentication_id;
  insert into app_private.user_authentication_secrets (user_authentication_id, details) values
    (v_user_authentication_id, f_auth_details);

  return v_user;
end;
$$;


--
-- Name: FUNCTION register_user(f_service character varying, f_identifier character varying, f_profile json, f_auth_details json, f_email_is_verified boolean); Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON FUNCTION app_private.register_user(f_service character varying, f_identifier character varying, f_profile json, f_auth_details json, f_email_is_verified boolean) IS 'Used to register a user from information gleaned from OAuth. Primarily used by link_or_register_user';


--
-- Name: tg__set_updated_at(); Type: FUNCTION; Schema: app_private; Owner: -
--

CREATE FUNCTION app_private.tg__set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at := current_timestamp;
  return new;
end;
$$;


--
-- Name: web_login(text, text); Type: FUNCTION; Schema: app_private; Owner: -
--

CREATE FUNCTION app_private.web_login(username text, password text) RETURNS app_public.users
    LANGUAGE plpgsql STRICT SECURITY DEFINER
    SET search_path TO '$user', 'public'
    AS $$
declare
  v_user app_public.users;
  v_user_secret app_private.user_secrets;
  v_login_attempt_window_duration interval = interval '6 hours';
begin
  select * into v_user from app_public.user_by_username_or_verified_email(username);

  if not (v_user is null) then
    -- Load their secrets
    select * into v_user_secret from app_private.user_secrets
    where id = v_user.user_secret_id;

    -- Have there been too many login attempts?
    if (
      v_user_secret.first_failed_password_attempt is not null
    and
      v_user_secret.first_failed_password_attempt > NOW() - v_login_attempt_window_duration
    and
      v_user_secret.password_attempts >= 20
    ) then
      --  User account locked - too many login attempts
      raise exception 'APP_EXCEPTION__LOGIN__ACCOUNT_LOCKED_TOO_MANY_ATTEMPTS' using errcode = 'LOCKD';
    end if;

    -- Not too many login attempts, let's check the password
    if v_user_secret.password_hash = crypt(password, v_user_secret.password_hash) then
      -- Excellent - they're loggged in! Let's reset the attempt tracking
      update app_private.user_secrets
      set password_attempts = 0, first_failed_password_attempt = null
      where id = v_user.user_secret_id;
      return v_user;
    else
      -- Wrong password, bump all the attempt tracking figures
      update app_private.user_secrets
      set
        password_attempts = (
          case
          when first_failed_password_attempt is null
            or first_failed_password_attempt < now() - v_login_attempt_window_duration
            then 1
          else password_attempts + 1 end
        ),

        first_failed_password_attempt = (
          case
          when first_failed_password_attempt is null
            or first_failed_password_attempt < now() - v_login_attempt_window_duration
            then now()
          else first_failed_password_attempt end
        )
      where id = v_user.user_secret_id;
      return null;
    end if;
  else
    -- No user with that email/username was found
    return null;
  end if;
end;
$$;


--
-- Name: FUNCTION web_login(username text, password text); Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON FUNCTION app_private.web_login(username text, password text) IS 'Returns a user that matches the username/password combo, or null on failure.';


--
-- Name: current_user(); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public."current_user"() RETURNS app_public.users
    LANGUAGE sql STABLE
    SET search_path TO '$user', 'public'
    AS $$
  select users.*
    from app_public.users
    where id = app_public.current_user_id_or_null();
$$;


--
-- Name: FUNCTION "current_user"(); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public."current_user"() IS 'The currently logged in user (or null if not logged in).';


--
-- Name: current_user_id_or_null(); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.current_user_id_or_null() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select nullif(current_setting('jwt.claims.user_id', true), '')::uuid;
$$;


--
-- Name: FUNCTION current_user_id_or_null(); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public.current_user_id_or_null() IS '@omit
Handy method to get the current user ID for use in RLS policies, etc; in GraphQL, use `query { currentUser { id } }` instead.';


--
-- Name: current_user_id_required(); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.current_user_id_required() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select current_setting('jwt.claims.user_id', false)::uuid;
$$;


--
-- Name: FUNCTION current_user_id_required(); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public.current_user_id_required() IS '@omit
Get current user id or raise error that returns 403 status code';


--
-- Name: forgot_password(text); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.forgot_password(email text) RETURNS boolean
    LANGUAGE plpgsql STRICT SECURITY DEFINER
    SET search_path TO '$user', 'public'
    AS $$
declare
  v_user_email app_hidden.user_emails;
  v_reset_token text;
  v_reset_min_duration_between_emails interval = interval '30 minutes';
  v_reset_max_duration interval = interval '3 days';
begin
  -- Find the matching user_email
  select user_emails.* into v_user_email
  from app_hidden.user_emails
  where user_emails.email = forgot_password.email::citext
  order by is_verified desc, id desc;

  if not (v_user_email is null) then
    -- See if we've triggered a reset recently
    if exists(
      select 1
      from app_private.user_email_secrets
      where user_email_id = v_user_email.id
      and password_reset_email_sent_at is not null
      and password_reset_email_sent_at > now() - v_reset_min_duration_between_emails
    ) then
      return true;
    end if;

    -- Fetch or generate reset token
    update app_private.user_secrets
    set
      reset_password_token = (
        case
        when reset_password_token is null or reset_password_token_generated_at < NOW() - v_reset_max_duration
        then encode(gen_random_bytes(6), 'hex')
        else reset_password_token
        end
      ),
      reset_password_token_generated_at = (
        case
        when reset_password_token is null or reset_password_token_generated_at < NOW() - v_reset_max_duration
        then now()
        else reset_password_token_generated_at
        end
      )
    where user_id = v_user_email.user_id
    returning reset_password_token into v_reset_token;

    -- Trigger email send
    perform graphile_worker.add_job(
      'sendPasswordResetEmail',
      json_build_object(
        'id', v_user_email.id
      )
    );

    return true;

  end if;
  return false;
end;
$$;


--
-- Name: FUNCTION forgot_password(email text); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public.forgot_password(email text) IS '@resultFieldName success
If you''ve forgotten your password, give us one of your email addresses and we'' send you a reset token. Note this only works if you have added an email address!';


--
-- Name: generate_url_safe_token(); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.generate_url_safe_token() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select translate(
    encode(gen_random_bytes(8), 'base64'),
    '+/=',
    ''
  )
$$;


--
-- Name: FUNCTION generate_url_safe_token(); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public.generate_url_safe_token() IS '@omit';


--
-- Name: reset_password(uuid, text, text); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.reset_password(user_id uuid, token text, new_password text) RETURNS app_public.users
    LANGUAGE plpgsql STRICT SECURITY DEFINER
    SET search_path TO '$user', 'public'
    AS $$
declare
  v_user app_public.users;
  v_user_email app_hidden.user_emails;
  v_user_secret app_private.user_secrets;
  v_reset_max_duration interval = interval '3 days';
  v_max_reset_password_attempts int = 20;
begin
  select users.* into v_user
  from app_public.users
  where id = user_id;

  if not (v_user is null) then
    -- Load their secrets
    select * into v_user_secret from app_private.user_secrets
    where user_secrets.user_id = v_user.id;

    -- Have there been too many reset attempts?
    if (
      v_user_secret.first_failed_reset_password_attempt is not null
    and
      v_user_secret.first_failed_reset_password_attempt > NOW() - v_reset_max_duration
    and
      v_user_secret.reset_password_attempts >= v_max_reset_password_attempts
    ) then
      -- Password reset locked - too many reset attempts
      raise exception 'APP_EXCEPTION__RESET_PASSWORD__ACCOUNT_LOCKED_TOO_MANY_ATTEMPTS' using errcode = 'LOCKD';
    end if;

    -- Not too many reset attempts, let's check the token
    if v_user_secret.reset_password_token = token then
      -- Excellent - they're legit; let's reset the password as requested
      update app_private.user_secrets
      set
        password_hash = crypt(new_password, gen_salt('bf')),
        password_attempts = 0,
        first_failed_password_attempt = null,
        reset_password_token = null,
        reset_password_token_generated_at = null,
        reset_password_attempts = 0,
        first_failed_reset_password_attempt = null
      where user_secrets.user_id = v_user.id;

      -- Notify that password has been reset
      select * into v_user_email
      from app_hidden.user_emails
      where user_emails.user_id = reset_password.user_id
      and is_verified = true
      order by created_at
      limit 1;

      if v_user_email is not NULL then
        perform graphile_worker.add_job(
          'sendEmail',
          json_build_object(
            'to', v_user_email.email,
            'subject', 'Your password has been changed',
            'text', 'Your password has been changed. If you didn''t do this, please contact support immediately.'
          )
        );
      end if;

      return v_user;
    else
      -- Wrong token, bump all the attempt tracking figures
      update app_private.user_secrets
      set
        reset_password_attempts = (
          case
          when first_failed_reset_password_attempt is null
            or first_failed_reset_password_attempt < now() - v_reset_max_duration
            then 1
          else reset_password_attempts + 1
          end
        ),

        first_failed_reset_password_attempt = (
          case when first_failed_reset_password_attempt is null
            or first_failed_reset_password_attempt < now() - v_reset_max_duration
            then now()
          else first_failed_reset_password_attempt
          end
        )
      where user_secrets.user_id = v_user.id;
      /* Invalid token */
      raise exception 'APP_EXCEPTION__RESET_PASSWORD__INVALID_TOKEN' using errcode='INVLD';
    end if;
  else
    -- No user with that id was found
    /* Invalid user ID */
    raise exception 'APP_EXCEPTION__RESET_PASSWORD__INVALID_USER_ID' using errcode='INVLD';
  end if;
end;
$$;


--
-- Name: FUNCTION reset_password(user_id uuid, token text, new_password text); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public.reset_password(user_id uuid, token text, new_password text) IS 'After triggering forgotPassword, you''ll be sent a reset token. Combine this with your user ID and a new password to reset your password.';


--
-- Name: user_by_username_or_verified_email(text); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.user_by_username_or_verified_email(username_or_email text) RETURNS app_public.users
    LANGUAGE sql STABLE STRICT
    SET search_path TO '$user', 'public'
    AS $$
  select users.*
  from app_public.users
  where
    -- Match username against users username, or any verified email address
    (
      users.username = user_by_username_or_verified_email.username_or_email
    or
      exists(
        select 1
        from app_hidden.user_emails
        where user_id = users.id
        and is_verified is true
        and email = user_by_username_or_verified_email.username_or_email::citext
      )
    );
$$;


--
-- Name: user_emails; Type: TABLE; Schema: app_hidden; Owner: -
--

CREATE TABLE app_hidden.user_emails (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    email public.citext NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT user_emails_email_check CHECK ((email OPERATOR(public.~) '[^@]+@[^@]+\.[^@]+'::public.citext))
);


--
-- Name: TABLE user_emails; Type: COMMENT; Schema: app_hidden; Owner: -
--

COMMENT ON TABLE app_hidden.user_emails IS '@omit all
Information about a user''s email address.';


--
-- Name: COLUMN user_emails.email; Type: COMMENT; Schema: app_hidden; Owner: -
--

COMMENT ON COLUMN app_hidden.user_emails.email IS 'The users email address, in `a@b.c` format.';


--
-- Name: COLUMN user_emails.is_verified; Type: COMMENT; Schema: app_hidden; Owner: -
--

COMMENT ON COLUMN app_hidden.user_emails.is_verified IS 'True if the user has is_verified their email address (by clicking the link in the email we sent them, or logging in with a social login provider), false otherwise.';


--
-- Name: verify_user_email(text); Type: FUNCTION; Schema: app_public; Owner: -
--

CREATE FUNCTION app_public.verify_user_email(token text) RETURNS app_hidden.user_emails
    LANGUAGE plpgsql STRICT SECURITY DEFINER
    SET search_path TO '$user', 'public'
    AS $$
declare
  v_user_email app_hidden.user_emails;
  v_max_duration interval = interval '7 days';
begin
  UPDATE app_hidden.user_emails
  SET is_verified = true
  WHERE id = (
    SELECT user_email_id
    FROM app_private.user_email_secrets
    WHERE user_email_secrets.verification_token = token
    AND user_email_secrets.verification_email_sent_at > now() - v_max_duration
  )
  RETURNING * INTO v_user_email;

  if v_user_email is NULL THEN
    /* verification token is invalid or expired */
    raise exception 'APP_EXCEPTION__VERIFY_USER_EMAIL__TOKEN_INVALID_OR_EXPIRED' using errcode='INVLD';
  end if;

  return v_user_email;
end;
$$;


--
-- Name: FUNCTION verify_user_email(token text); Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON FUNCTION app_public.verify_user_email(token text) IS '@resultFieldName userEmail
After you add an email address, you will receive an email with a verification token. Give us the verification token to mark that email as verified!';


--
-- Name: jobs; Type: TABLE; Schema: graphile_worker; Owner: -
--

CREATE TABLE graphile_worker.jobs (
    id bigint NOT NULL,
    queue_name text DEFAULT (public.gen_random_uuid())::text,
    task_identifier text NOT NULL,
    payload json DEFAULT '{}'::json NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    max_attempts integer DEFAULT 25 NOT NULL,
    last_error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    key text,
    locked_at timestamp with time zone,
    locked_by text,
    revision integer DEFAULT 0 NOT NULL,
    flags jsonb,
    CONSTRAINT jobs_key_check CHECK ((length(key) > 0))
);


--
-- Name: add_job(text, json, text, timestamp with time zone, integer, text, integer, text[]); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.add_job(identifier text, payload json DEFAULT NULL::json, queue_name text DEFAULT NULL::text, run_at timestamp with time zone DEFAULT NULL::timestamp with time zone, max_attempts integer DEFAULT NULL::integer, job_key text DEFAULT NULL::text, priority integer DEFAULT NULL::integer, flags text[] DEFAULT NULL::text[]) RETURNS graphile_worker.jobs
    LANGUAGE plpgsql
    AS $$
declare
  v_job "graphile_worker".jobs;
begin
  -- Apply rationality checks
  if length(identifier) > 128 then
    raise exception 'Task identifier is too long (max length: 128).' using errcode = 'GWBID';
  end if;
  if queue_name is not null and length(queue_name) > 128 then
    raise exception 'Job queue name is too long (max length: 128).' using errcode = 'GWBQN';
  end if;
  if job_key is not null and length(job_key) > 512 then
    raise exception 'Job key is too long (max length: 512).' using errcode = 'GWBJK';
  end if;
  if max_attempts < 1 then
    raise exception 'Job maximum attempts must be at least 1' using errcode = 'GWBMA';
  end if;

  if job_key is not null then
    -- Upsert job
    insert into "graphile_worker".jobs (
      task_identifier,
      payload,
      queue_name,
      run_at,
      max_attempts,
      key,
      priority,
      flags
    )
      values(
        identifier,
        coalesce(payload, '{}'::json),
        queue_name,
        coalesce(run_at, now()),
        coalesce(max_attempts, 25),
        job_key,
        coalesce(priority, 0),
        (
          select jsonb_object_agg(flag, true)
          from unnest(flags) as item(flag)
        )
      )
      on conflict (key) do update set
        task_identifier=excluded.task_identifier,
        payload=excluded.payload,
        queue_name=excluded.queue_name,
        max_attempts=excluded.max_attempts,
        run_at=excluded.run_at,
        priority=excluded.priority,
        revision=jobs.revision + 1,
        flags=excluded.flags,

        -- always reset error/retry state
        attempts=0,
        last_error=null
      where jobs.locked_at is null
      returning *
      into v_job;

    -- If upsert succeeded (insert or update), return early
    if not (v_job is null) then
      return v_job;
    end if;

    -- Upsert failed -> there must be an existing job that is locked. Remove
    -- existing key to allow a new one to be inserted, and prevent any
    -- subsequent retries by bumping attempts to the max allowed.
    update "graphile_worker".jobs
      set
        key = null,
        attempts = jobs.max_attempts
      where key = job_key;
  end if;

  -- insert the new job. Assume no conflicts due to the update above
  insert into "graphile_worker".jobs(
    task_identifier,
    payload,
    queue_name,
    run_at,
    max_attempts,
    key,
    priority,
    flags
  )
    values(
      identifier,
      coalesce(payload, '{}'::json),
      queue_name,
      coalesce(run_at, now()),
      coalesce(max_attempts, 25),
      job_key,
      coalesce(priority, 0),
      (
        select jsonb_object_agg(flag, true)
        from unnest(flags) as item(flag)
      )
    )
    returning *
    into v_job;

  return v_job;
end;
$$;


--
-- Name: complete_job(text, bigint); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.complete_job(worker_id text, job_id bigint) RETURNS graphile_worker.jobs
    LANGUAGE plpgsql
    AS $$
declare
  v_row "graphile_worker".jobs;
begin
  delete from "graphile_worker".jobs
    where id = job_id
    returning * into v_row;

  if v_row.queue_name is not null then
    update "graphile_worker".job_queues
      set locked_by = null, locked_at = null
      where queue_name = v_row.queue_name and locked_by = worker_id;
  end if;

  return v_row;
end;
$$;


--
-- Name: complete_jobs(bigint[]); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.complete_jobs(job_ids bigint[]) RETURNS SETOF graphile_worker.jobs
    LANGUAGE sql
    AS $$
  delete from "graphile_worker".jobs
    where id = any(job_ids)
    and (
      locked_by is null
    or
      locked_at < NOW() - interval '4 hours'
    )
    returning *;
$$;


--
-- Name: fail_job(text, bigint, text); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.fail_job(worker_id text, job_id bigint, error_message text) RETURNS graphile_worker.jobs
    LANGUAGE plpgsql STRICT
    AS $$
declare
  v_row "graphile_worker".jobs;
begin
  update "graphile_worker".jobs
    set
      last_error = error_message,
      run_at = greatest(now(), run_at) + (exp(least(attempts, 10))::text || ' seconds')::interval,
      locked_by = null,
      locked_at = null
    where id = job_id and locked_by = worker_id
    returning * into v_row;

  if v_row.queue_name is not null then
    update "graphile_worker".job_queues
      set locked_by = null, locked_at = null
      where queue_name = v_row.queue_name and locked_by = worker_id;
  end if;

  return v_row;
end;
$$;


--
-- Name: get_job(text, text[], interval, text[]); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.get_job(worker_id text, task_identifiers text[] DEFAULT NULL::text[], job_expiry interval DEFAULT '04:00:00'::interval, forbidden_flags text[] DEFAULT NULL::text[]) RETURNS graphile_worker.jobs
    LANGUAGE plpgsql
    AS $$
declare
  v_job_id bigint;
  v_queue_name text;
  v_row "graphile_worker".jobs;
  v_now timestamptz = now();
begin
  if worker_id is null or length(worker_id) < 10 then
    raise exception 'invalid worker id';
  end if;

  select jobs.queue_name, jobs.id into v_queue_name, v_job_id
    from "graphile_worker".jobs
    where (jobs.locked_at is null or jobs.locked_at < (v_now - job_expiry))
    and (
      jobs.queue_name is null
    or
      exists (
        select 1
        from "graphile_worker".job_queues
        where job_queues.queue_name = jobs.queue_name
        and (job_queues.locked_at is null or job_queues.locked_at < (v_now - job_expiry))
        for update
        skip locked
      )
    )
    and run_at <= v_now
    and attempts < max_attempts
    and (task_identifiers is null or task_identifier = any(task_identifiers))
    and (forbidden_flags is null or (flags ?| forbidden_flags) is not true)
    order by priority asc, run_at asc, id asc
    limit 1
    for update
    skip locked;

  if v_job_id is null then
    return null;
  end if;

  if v_queue_name is not null then
    update "graphile_worker".job_queues
      set
        locked_by = worker_id,
        locked_at = v_now
      where job_queues.queue_name = v_queue_name;
  end if;

  update "graphile_worker".jobs
    set
      attempts = attempts + 1,
      locked_by = worker_id,
      locked_at = v_now
    where id = v_job_id
    returning * into v_row;

  return v_row;
end;
$$;


--
-- Name: jobs__decrease_job_queue_count(); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.jobs__decrease_job_queue_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  v_new_job_count int;
begin
  update "graphile_worker".job_queues
    set job_count = job_queues.job_count - 1
    where queue_name = old.queue_name
    returning job_count into v_new_job_count;

  if v_new_job_count <= 0 then
    delete from "graphile_worker".job_queues where queue_name = old.queue_name and job_count <= 0;
  end if;

  return old;
end;
$$;


--
-- Name: jobs__increase_job_queue_count(); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.jobs__increase_job_queue_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  insert into "graphile_worker".job_queues(queue_name, job_count)
    values(new.queue_name, 1)
    on conflict (queue_name)
    do update
    set job_count = job_queues.job_count + 1;

  return new;
end;
$$;


--
-- Name: permanently_fail_jobs(bigint[], text); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.permanently_fail_jobs(job_ids bigint[], error_message text DEFAULT NULL::text) RETURNS SETOF graphile_worker.jobs
    LANGUAGE sql
    AS $$
  update "graphile_worker".jobs
    set
      last_error = coalesce(error_message, 'Manually marked as failed'),
      attempts = max_attempts
    where id = any(job_ids)
    and (
      locked_by is null
    or
      locked_at < NOW() - interval '4 hours'
    )
    returning *;
$$;


--
-- Name: remove_job(text); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.remove_job(job_key text) RETURNS graphile_worker.jobs
    LANGUAGE sql STRICT
    AS $$
  delete from "graphile_worker".jobs
    where key = job_key
    and locked_at is null
  returning *;
$$;


--
-- Name: reschedule_jobs(bigint[], timestamp with time zone, integer, integer, integer); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.reschedule_jobs(job_ids bigint[], run_at timestamp with time zone DEFAULT NULL::timestamp with time zone, priority integer DEFAULT NULL::integer, attempts integer DEFAULT NULL::integer, max_attempts integer DEFAULT NULL::integer) RETURNS SETOF graphile_worker.jobs
    LANGUAGE sql
    AS $$
  update "graphile_worker".jobs
    set
      run_at = coalesce(reschedule_jobs.run_at, jobs.run_at),
      priority = coalesce(reschedule_jobs.priority, jobs.priority),
      attempts = coalesce(reschedule_jobs.attempts, jobs.attempts),
      max_attempts = coalesce(reschedule_jobs.max_attempts, jobs.max_attempts)
    where id = any(job_ids)
    and (
      locked_by is null
    or
      locked_at < NOW() - interval '4 hours'
    )
    returning *;
$$;


--
-- Name: tg__update_timestamp(); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.tg__update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = greatest(now(), old.updated_at + interval '1 millisecond');
  return new;
end;
$$;


--
-- Name: tg_jobs__notify_new_jobs(); Type: FUNCTION; Schema: graphile_worker; Owner: -
--

CREATE FUNCTION graphile_worker.tg_jobs__notify_new_jobs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify('jobs:insert', '');
  return new;
end;
$$;


--
-- Name: user_authentication_secrets; Type: TABLE; Schema: app_private; Owner: -
--

CREATE TABLE app_private.user_authentication_secrets (
    user_authentication_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    details jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: user_email_secrets; Type: TABLE; Schema: app_private; Owner: -
--

CREATE TABLE app_private.user_email_secrets (
    user_email_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    verification_token text,
    verification_email_sent_at timestamp with time zone,
    password_reset_email_sent_at timestamp with time zone
);


--
-- Name: TABLE user_email_secrets; Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON TABLE app_private.user_email_secrets IS 'The contents of this table should never be visible to the user. Contains data mostly related to email verification and avoiding spamming users.';


--
-- Name: COLUMN user_email_secrets.verification_email_sent_at; Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON COLUMN app_private.user_email_secrets.verification_email_sent_at IS 'We store the time the last verification email was sent to this email to prevent the email getting flooded.';


--
-- Name: COLUMN user_email_secrets.password_reset_email_sent_at; Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON COLUMN app_private.user_email_secrets.password_reset_email_sent_at IS 'We store the time the last password reset was sent to this email to prevent the email getting flooded.';


--
-- Name: user_secrets; Type: TABLE; Schema: app_private; Owner: -
--

CREATE TABLE app_private.user_secrets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    password_hash text,
    reset_password_token text,
    reset_password_token_generated_at timestamp with time zone,
    first_failed_reset_password_attempt timestamp with time zone,
    first_failed_password_attempt timestamp with time zone,
    reset_password_attempts integer DEFAULT 0 NOT NULL,
    password_attempts integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE user_secrets; Type: COMMENT; Schema: app_private; Owner: -
--

COMMENT ON TABLE app_private.user_secrets IS 'The contents of this table should never be visible to the user. Contains data mostly related to authentication.';


--
-- Name: user_sessions; Type: TABLE; Schema: app_private; Owner: -
--

CREATE TABLE app_private.user_sessions (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


--
-- Name: posts; Type: TABLE; Schema: app_public; Owner: -
--

CREATE TABLE app_public.posts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    content character varying(255) NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT posts_name_check CHECK (((name)::text <> ''::text)),
    CONSTRAINT posts_name_check1 CHECK (((name)::text <> ''::text))
);


--
-- Name: user_authentications; Type: TABLE; Schema: app_public; Owner: -
--

CREATE TABLE app_public.user_authentications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    service text NOT NULL,
    identifier text NOT NULL,
    details jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE user_authentications; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON TABLE app_public.user_authentications IS '@omit all
Contains information about the login providers this user has used, so that they may disconnect them should they wish.';


--
-- Name: COLUMN user_authentications.user_id; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.user_authentications.user_id IS '@omit';


--
-- Name: COLUMN user_authentications.service; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.user_authentications.service IS 'The login service used, e.g. `twitter` or `github`.';


--
-- Name: COLUMN user_authentications.identifier; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.user_authentications.identifier IS 'A unique identifier for the user within the login service.';


--
-- Name: COLUMN user_authentications.details; Type: COMMENT; Schema: app_public; Owner: -
--

COMMENT ON COLUMN app_public.user_authentications.details IS '@omit
Additional profile details extracted from this login method';


--
-- Name: job_queues; Type: TABLE; Schema: graphile_worker; Owner: -
--

CREATE TABLE graphile_worker.job_queues (
    queue_name text NOT NULL,
    job_count integer NOT NULL,
    locked_at timestamp with time zone,
    locked_by text
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: graphile_worker; Owner: -
--

CREATE SEQUENCE graphile_worker.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: graphile_worker; Owner: -
--

ALTER SEQUENCE graphile_worker.jobs_id_seq OWNED BY graphile_worker.jobs.id;


--
-- Name: migrations; Type: TABLE; Schema: graphile_worker; Owner: -
--

CREATE TABLE graphile_worker.migrations (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: shmig_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shmig_version (
    version integer NOT NULL,
    migrated_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: jobs id; Type: DEFAULT; Schema: graphile_worker; Owner: -
--

ALTER TABLE ONLY graphile_worker.jobs ALTER COLUMN id SET DEFAULT nextval('graphile_worker.jobs_id_seq'::regclass);


--
-- Name: user_emails user_emails_pkey; Type: CONSTRAINT; Schema: app_hidden; Owner: -
--

ALTER TABLE ONLY app_hidden.user_emails
    ADD CONSTRAINT user_emails_pkey PRIMARY KEY (id);


--
-- Name: user_emails user_emails_user_id_email_key; Type: CONSTRAINT; Schema: app_hidden; Owner: -
--

ALTER TABLE ONLY app_hidden.user_emails
    ADD CONSTRAINT user_emails_user_id_email_key UNIQUE (user_id, email);


--
-- Name: user_sessions app_private_user_sessions_pkey; Type: CONSTRAINT; Schema: app_private; Owner: -
--

ALTER TABLE ONLY app_private.user_sessions
    ADD CONSTRAINT app_private_user_sessions_pkey PRIMARY KEY (sid);


--
-- Name: user_authentication_secrets user_authentication_secrets_pkey; Type: CONSTRAINT; Schema: app_private; Owner: -
--

ALTER TABLE ONLY app_private.user_authentication_secrets
    ADD CONSTRAINT user_authentication_secrets_pkey PRIMARY KEY (user_authentication_id);


--
-- Name: user_email_secrets user_email_secrets_pkey; Type: CONSTRAINT; Schema: app_private; Owner: -
--

ALTER TABLE ONLY app_private.user_email_secrets
    ADD CONSTRAINT user_email_secrets_pkey PRIMARY KEY (user_email_id);


--
-- Name: user_secrets user_secrets_pkey; Type: CONSTRAINT; Schema: app_private; Owner: -
--

ALTER TABLE ONLY app_private.user_secrets
    ADD CONSTRAINT user_secrets_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: user_authentications uniq_user_authentications; Type: CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.user_authentications
    ADD CONSTRAINT uniq_user_authentications UNIQUE (service, identifier);


--
-- Name: user_authentications user_authentications_pkey; Type: CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.user_authentications
    ADD CONSTRAINT user_authentications_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: job_queues job_queues_pkey; Type: CONSTRAINT; Schema: graphile_worker; Owner: -
--

ALTER TABLE ONLY graphile_worker.job_queues
    ADD CONSTRAINT job_queues_pkey PRIMARY KEY (queue_name);


--
-- Name: jobs jobs_key_key; Type: CONSTRAINT; Schema: graphile_worker; Owner: -
--

ALTER TABLE ONLY graphile_worker.jobs
    ADD CONSTRAINT jobs_key_key UNIQUE (key);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: graphile_worker; Owner: -
--

ALTER TABLE ONLY graphile_worker.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: graphile_worker; Owner: -
--

ALTER TABLE ONLY graphile_worker.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: shmig_version shmig_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shmig_version
    ADD CONSTRAINT shmig_version_pkey PRIMARY KEY (version);


--
-- Name: uniq_user_emails_verified_email; Type: INDEX; Schema: app_hidden; Owner: -
--

CREATE UNIQUE INDEX uniq_user_emails_verified_email ON app_hidden.user_emails USING btree (email) WHERE (is_verified IS TRUE);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: app_private; Owner: -
--

CREATE INDEX "IDX_session_expire" ON app_private.user_sessions USING btree (expire);


--
-- Name: app_public_posts_user_id; Type: INDEX; Schema: app_public; Owner: -
--

CREATE INDEX app_public_posts_user_id ON app_public.posts USING btree (user_id);


--
-- Name: uniq_user_user_secret_id; Type: INDEX; Schema: app_public; Owner: -
--

CREATE UNIQUE INDEX uniq_user_user_secret_id ON app_public.users USING btree (user_secret_id);


--
-- Name: user_authentications_user_id_idx; Type: INDEX; Schema: app_public; Owner: -
--

CREATE INDEX user_authentications_user_id_idx ON app_public.user_authentications USING btree (user_id);


--
-- Name: jobs_priority_run_at_id_idx; Type: INDEX; Schema: graphile_worker; Owner: -
--

CREATE INDEX jobs_priority_run_at_id_idx ON graphile_worker.jobs USING btree (priority, run_at, id);


--
-- Name: user_emails _100_timestamps; Type: TRIGGER; Schema: app_hidden; Owner: -
--

CREATE TRIGGER _100_timestamps BEFORE UPDATE ON app_hidden.user_emails FOR EACH ROW EXECUTE FUNCTION app_private.tg__set_updated_at();


--
-- Name: posts _100_timestamps; Type: TRIGGER; Schema: app_public; Owner: -
--

CREATE TRIGGER _100_timestamps BEFORE UPDATE ON app_public.posts FOR EACH ROW EXECUTE FUNCTION app_private.tg__set_updated_at();


--
-- Name: user_authentications _100_timestamps; Type: TRIGGER; Schema: app_public; Owner: -
--

CREATE TRIGGER _100_timestamps BEFORE UPDATE ON app_public.user_authentications FOR EACH ROW EXECUTE FUNCTION app_private.tg__set_updated_at();


--
-- Name: users _100_timestamps; Type: TRIGGER; Schema: app_public; Owner: -
--

CREATE TRIGGER _100_timestamps BEFORE UPDATE ON app_public.users FOR EACH ROW EXECUTE FUNCTION app_private.tg__set_updated_at();


--
-- Name: jobs _100_timestamps; Type: TRIGGER; Schema: graphile_worker; Owner: -
--

CREATE TRIGGER _100_timestamps BEFORE UPDATE ON graphile_worker.jobs FOR EACH ROW EXECUTE FUNCTION graphile_worker.tg__update_timestamp();


--
-- Name: jobs _500_decrease_job_queue_count; Type: TRIGGER; Schema: graphile_worker; Owner: -
--

CREATE TRIGGER _500_decrease_job_queue_count AFTER DELETE ON graphile_worker.jobs FOR EACH ROW WHEN ((old.queue_name IS NOT NULL)) EXECUTE FUNCTION graphile_worker.jobs__decrease_job_queue_count();


--
-- Name: jobs _500_decrease_job_queue_count_update; Type: TRIGGER; Schema: graphile_worker; Owner: -
--

CREATE TRIGGER _500_decrease_job_queue_count_update AFTER UPDATE OF queue_name ON graphile_worker.jobs FOR EACH ROW WHEN (((new.queue_name IS DISTINCT FROM old.queue_name) AND (old.queue_name IS NOT NULL))) EXECUTE FUNCTION graphile_worker.jobs__decrease_job_queue_count();


--
-- Name: jobs _500_increase_job_queue_count; Type: TRIGGER; Schema: graphile_worker; Owner: -
--

CREATE TRIGGER _500_increase_job_queue_count AFTER INSERT ON graphile_worker.jobs FOR EACH ROW WHEN ((new.queue_name IS NOT NULL)) EXECUTE FUNCTION graphile_worker.jobs__increase_job_queue_count();


--
-- Name: jobs _500_increase_job_queue_count_update; Type: TRIGGER; Schema: graphile_worker; Owner: -
--

CREATE TRIGGER _500_increase_job_queue_count_update AFTER UPDATE OF queue_name ON graphile_worker.jobs FOR EACH ROW WHEN (((new.queue_name IS DISTINCT FROM old.queue_name) AND (new.queue_name IS NOT NULL))) EXECUTE FUNCTION graphile_worker.jobs__increase_job_queue_count();


--
-- Name: jobs _900_notify_worker; Type: TRIGGER; Schema: graphile_worker; Owner: -
--

CREATE TRIGGER _900_notify_worker AFTER INSERT ON graphile_worker.jobs FOR EACH STATEMENT EXECUTE FUNCTION graphile_worker.tg_jobs__notify_new_jobs();


--
-- Name: user_emails user_emails_user_id_fkey; Type: FK CONSTRAINT; Schema: app_hidden; Owner: -
--

ALTER TABLE ONLY app_hidden.user_emails
    ADD CONSTRAINT user_emails_user_id_fkey FOREIGN KEY (user_id) REFERENCES app_public.users(id) ON DELETE CASCADE;


--
-- Name: user_authentication_secrets user_authentication_secrets_user_authentication_id_fkey; Type: FK CONSTRAINT; Schema: app_private; Owner: -
--

ALTER TABLE ONLY app_private.user_authentication_secrets
    ADD CONSTRAINT user_authentication_secrets_user_authentication_id_fkey FOREIGN KEY (user_authentication_id) REFERENCES app_public.user_authentications(id) ON DELETE CASCADE;


--
-- Name: user_email_secrets user_email_secrets_user_email_id_fkey; Type: FK CONSTRAINT; Schema: app_private; Owner: -
--

ALTER TABLE ONLY app_private.user_email_secrets
    ADD CONSTRAINT user_email_secrets_user_email_id_fkey FOREIGN KEY (user_email_id) REFERENCES app_hidden.user_emails(id) ON DELETE CASCADE;


--
-- Name: posts posts_user_id_fkey; Type: FK CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.posts
    ADD CONSTRAINT posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES app_public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_authentications user_authentications_user_id_fkey; Type: FK CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.user_authentications
    ADD CONSTRAINT user_authentications_user_id_fkey FOREIGN KEY (user_id) REFERENCES app_public.users(id) ON DELETE CASCADE;


--
-- Name: users users_user_secret_id_fkey; Type: FK CONSTRAINT; Schema: app_public; Owner: -
--

ALTER TABLE ONLY app_public.users
    ADD CONSTRAINT users_user_secret_id_fkey FOREIGN KEY (user_secret_id) REFERENCES app_private.user_secrets(id) ON DELETE CASCADE;


--
-- Name: user_emails delete_own; Type: POLICY; Schema: app_hidden; Owner: -
--

CREATE POLICY delete_own ON app_hidden.user_emails FOR DELETE USING ((user_id = app_public.current_user_id_or_null()));


--
-- Name: user_emails insert_own; Type: POLICY; Schema: app_hidden; Owner: -
--

CREATE POLICY insert_own ON app_hidden.user_emails FOR INSERT WITH CHECK ((user_id = app_public.current_user_id_or_null()));


--
-- Name: user_emails select_own; Type: POLICY; Schema: app_hidden; Owner: -
--

CREATE POLICY select_own ON app_hidden.user_emails FOR SELECT USING (true);


--
-- Name: user_emails; Type: ROW SECURITY; Schema: app_hidden; Owner: -
--

ALTER TABLE app_hidden.user_emails ENABLE ROW LEVEL SECURITY;

--
-- Name: user_authentication_secrets; Type: ROW SECURITY; Schema: app_private; Owner: -
--

ALTER TABLE app_private.user_authentication_secrets ENABLE ROW LEVEL SECURITY;

--
-- Name: user_email_secrets; Type: ROW SECURITY; Schema: app_private; Owner: -
--

ALTER TABLE app_private.user_email_secrets ENABLE ROW LEVEL SECURITY;

--
-- Name: user_secrets; Type: ROW SECURITY; Schema: app_private; Owner: -
--

ALTER TABLE app_private.user_secrets ENABLE ROW LEVEL SECURITY;

--
-- Name: user_authentications delete_own; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY delete_own ON app_public.user_authentications FOR DELETE USING ((user_id = app_public.current_user_id_or_null()));


--
-- Name: posts delete_posts; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY delete_posts ON app_public.posts FOR DELETE USING ((user_id = app_public.current_user_id_or_null()));


--
-- Name: users delete_self; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY delete_self ON app_public.users FOR DELETE USING ((id = app_public.current_user_id_or_null()));


--
-- Name: posts; Type: ROW SECURITY; Schema: app_public; Owner: -
--

ALTER TABLE app_public.posts ENABLE ROW LEVEL SECURITY;

--
-- Name: users select_all; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY select_all ON app_public.users FOR SELECT USING (true);


--
-- Name: user_authentications select_own; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY select_own ON app_public.user_authentications FOR SELECT USING ((user_id = app_public.current_user_id_or_null()));


--
-- Name: posts select_posts; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY select_posts ON app_public.posts FOR SELECT USING (true);


--
-- Name: posts update_posts; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY update_posts ON app_public.posts FOR UPDATE USING ((user_id = app_public.current_user_id_or_null()));


--
-- Name: users update_self; Type: POLICY; Schema: app_public; Owner: -
--

CREATE POLICY update_self ON app_public.users FOR UPDATE USING ((id = app_public.current_user_id_or_null()));


--
-- Name: user_authentications; Type: ROW SECURITY; Schema: app_public; Owner: -
--

ALTER TABLE app_public.user_authentications ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: app_public; Owner: -
--

ALTER TABLE app_public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: job_queues; Type: ROW SECURITY; Schema: graphile_worker; Owner: -
--

ALTER TABLE graphile_worker.job_queues ENABLE ROW LEVEL SECURITY;

--
-- Name: jobs; Type: ROW SECURITY; Schema: graphile_worker; Owner: -
--

ALTER TABLE graphile_worker.jobs ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA app_hidden; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA app_hidden TO app_anonymous;
GRANT USAGE ON SCHEMA app_hidden TO app_user;


--
-- Name: SCHEMA app_public; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA app_public TO app_anonymous;
GRANT USAGE ON SCHEMA app_public TO app_user;


--
-- Name: TABLE users; Type: ACL; Schema: app_public; Owner: -
--

GRANT SELECT ON TABLE app_public.users TO app_anonymous;
GRANT SELECT,DELETE ON TABLE app_public.users TO app_user;


--
-- Name: COLUMN users.name; Type: ACL; Schema: app_public; Owner: -
--

GRANT UPDATE(name) ON TABLE app_public.users TO app_user;


--
-- Name: COLUMN users.avatar_url; Type: ACL; Schema: app_public; Owner: -
--

GRANT UPDATE(avatar_url) ON TABLE app_public.users TO app_user;


--
-- Name: TABLE user_emails; Type: ACL; Schema: app_hidden; Owner: -
--

GRANT SELECT ON TABLE app_hidden.user_emails TO app_anonymous;
GRANT SELECT,DELETE ON TABLE app_hidden.user_emails TO app_user;


--
-- Name: COLUMN user_emails.email; Type: ACL; Schema: app_hidden; Owner: -
--

GRANT INSERT(email) ON TABLE app_hidden.user_emails TO app_user;


--
-- Name: TABLE posts; Type: ACL; Schema: app_public; Owner: -
--

GRANT SELECT ON TABLE app_public.posts TO app_user;


--
-- Name: TABLE user_authentications; Type: ACL; Schema: app_public; Owner: -
--

GRANT SELECT,DELETE ON TABLE app_public.user_authentications TO app_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: app_hidden; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app_hidden REVOKE ALL ON SEQUENCES  FROM app_owner;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app_hidden GRANT SELECT,USAGE ON SEQUENCES  TO app_anonymous;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app_hidden GRANT SELECT,USAGE ON SEQUENCES  TO app_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: app_public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app_public REVOKE ALL ON SEQUENCES  FROM app_owner;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app_public GRANT SELECT,USAGE ON SEQUENCES  TO app_anonymous;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app_public GRANT SELECT,USAGE ON SEQUENCES  TO app_user;


--
-- PostgreSQL database dump complete
--


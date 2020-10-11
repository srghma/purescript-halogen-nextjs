-- Inspired by
-- https://stackoverflow.com/a/38846293/3574379

create sequence app_public.users_confirmation_token_seq
  cycle -- restart if max val reached
  owned by app_public.users.confirmation_token; -- remove seq if this column was removed

create or replace function app_public.next_users_confirmation_token() returns text as $function$
  select md5(nextval('app_public.users_confirmation_token_seq')::text);
$function$ LANGUAGE sql stable;

comment on function app_public.next_users_confirmation_token() is
  '@omit';

grant execute on function app_public.next_users_confirmation_token() to public;

create function
  app_public.users_full_name(a_user app_public.users) returns text as $$
    select (a_user.first_name || ' ' || a_user.last_name);
  $$ language sql
    strict
    stable;

comment on function app_public.users_full_name(a_user app_public.users) is 'a user’s full name which is a concatenation of their first and last name.';

grant execute on function app_public.users_full_name(app_public.users) to app_anonymous, app_user;

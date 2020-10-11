create function app_public.current_user() returns app_public.users as $$
  select *
  from app_public.users
  where id = app_public.current_user_id_or_null()
$$ language sql
  stable; -- function has no side effects, can be cached

comment on function app_public.current_user() is 'gets the users who was identified by our jwt.';

grant execute on function app_public.current_user() to app_anonymous, app_user;

alter table app_public.posts enable row level security;

grant select on table app_public.posts to app_anonymous;
grant select, update, delete on table app_public.posts to app_user;

create policy select_posts on app_public.posts for select to app_user
  using (true);

create policy update_posts on app_public.posts for update to app_user
  using (user_id = app_public.current_user_id_or_null());

create policy delete_posts on app_public.posts for delete to app_user
  using (user_id = app_public.current_user_id_or_null());

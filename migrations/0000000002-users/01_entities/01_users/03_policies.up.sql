alter table app_public.users enable row level security;

grant select on table app_public.users to app_anonymous;
grant select, update, delete on table app_public.users to app_user;

create policy select_users on app_public.users for select to app_user
  using (true);

create policy update_users on app_public.users for update to app_user
  using (id = app_public.current_user_id_or_null());

create policy delete_users on app_public.users for delete to app_user
  using (id = app_public.current_user_id_or_null());

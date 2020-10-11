grant select, delete on app_public.user_oauths to app_user;

alter table app_public.user_oauths enable row level security;

create policy select_own on app_public.user_oauths for select
  using (user_id = app_public.current_user_id_or_null());

create policy delete_own on app_public.user_oauths for delete
  using (user_id = app_public.current_user_id_or_null());

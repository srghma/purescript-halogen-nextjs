create trigger set_updated_at before update
  on app_public.posts
  for each row
  execute function app_private.tg__timestamps();

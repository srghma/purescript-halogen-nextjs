create trigger set_updated_at before update
  on app_public.posts
  for each row
  execute procedure app_private.tg__set_updated_at();

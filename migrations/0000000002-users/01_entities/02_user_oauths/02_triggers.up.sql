create trigger set_updated_at
  after insert or update on app_public.user_oauths
  for each row
  execute procedure app_private.tg__set_updated_at();

create function app_private.rabbitmq__send_confirmation_mail(a_user app_public.users) returns void as $$
declare
  data json;
  notification json;
begin
  data = json_build_object(
    'id',                 a_user.id,
    'first_name',         a_user.first_name,
    'last_name',          a_user.last_name,
    'avatar_url',         a_user.avatar_url,
    'email',              a_user.email,
    'confirmation_token', a_user.confirmation_token
  );

  notification = json_build_object(
    'type', 'user_confirm',
    'data', data
  );

  perform rabbitmq.send_message(
    'amq_direct',
    'mails',
    notification::text
  );
end;
$$ language plpgsql volatile set search_path from current;

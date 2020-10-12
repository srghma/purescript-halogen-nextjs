/*

The text value returned is used to tell the system when to cancel the subscription

select pg_notify(
  'CANCEL_ALL_SUBSCRIPTIONS',
  json_build_object()::text
);

*/

create function app_hidden.validate_subscription(topic text)
returns text as $$
declare
  user_id uuid;
begin
  if topic like 'postgraphile:excel_done:%' then
    user_id = substring(topic, '^postgraphile:excel_done:(.+)$');

    if user_id = app_public.current_user_id_required() then
      return 'CANCEL_ALL_SUBSCRIPTIONS'::text;
    else
      raise exception 'APP__EXCEPTION__VALIDATE_SUBSCRIPTION__INVALID_USER';
    end if;
  else
    raise exception 'APP__EXCEPTION__VALIDATE_SUBSCRIPTION__UNKNOWN_TOPIC';
  END if;
end;
$$ language plpgsql volatile security definer;

grant execute on function app_hidden.validate_subscription(text) to public;

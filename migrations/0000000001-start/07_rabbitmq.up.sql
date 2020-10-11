/*
This source code may reproduce and may modify the following components:

Name: rabbitmq.sql
Link to file: https://github.com/subzerocloud/subzero-starter-kit/blob/7b620760a6899911c318813084a5836dd05d6607/db/src/libs/rabbitmq.sql
Copyright: Copyright (c) 2017-present Ruslan Talpa, subZero Cloud LLC.
Licence: MIT (https://github.com/subzerocloud/subzero-starter-kit/blob/7b620760a6/LICENSE.txt)
*/

create schema rabbitmq;
grant usage on schema rabbitmq to public;

create function rabbitmq.send_message(
  exchange    text,
  routing_key text,
  message     text
) returns void as $$
  select pg_notify(
    exchange,
    routing_key || '|' || message
  );
$$ stable language sql;

grant execute on function rabbitmq.send_message(
  exchange    text,
  routing_key text,
  message     text
) to public;

-- TODO
-- consider checking if row is not too big
-- https://github.com/subzerocloud/subzero-starter-kit/blob/master/db/src/libs/rabbitmq/schema.sql
create function rabbitmq.on_row_change() returns trigger as $$
  declare
    routing_key text;
    row record;
  begin
    routing_key := 'row_change'
                   '.table-'::text || TG_TABLE_NAME::text ||
                   '.event-'::text || TG_OP::text;

    if (TG_OP = 'DELETE') then
        row := old;
    elsif (TG_OP = 'UPDATE') then
        row := new;
    elsif (TG_OP = 'INSERT') then
        row := new;
    end if;

    perform rabbitmq.send_message(
      'amq_topic', -- exchange
      routing_key,
      row_to_json(row)::text
    );

    return null;
  end;
$$ stable language plpgsql;

grant execute on function rabbitmq.on_row_change() to public;

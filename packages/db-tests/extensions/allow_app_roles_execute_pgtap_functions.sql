
-- allow our application roles execute pg_tap functions (like foreign_tables_are)
grant execute on all functions in schema public to app_visitor, app_user;
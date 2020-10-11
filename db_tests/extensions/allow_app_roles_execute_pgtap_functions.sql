
-- allow our application roles execute pg_tap functions (like foreign_tables_are)
grant execute on all functions in schema public to app_anonymous, app_user;

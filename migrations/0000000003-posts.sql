-- ====  UP  ====

begin;

\include 0000000003-posts/01_posts/01_table.up.sql
\include 0000000003-posts/01_posts/02_triggers.up.sql
\include 0000000003-posts/01_posts/03_policies.up.sql


commit;

-- ==== DOWN ====

-- do nothing, this should never happen
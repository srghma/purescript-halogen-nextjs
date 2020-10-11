-- ====  UP  ====

begin;

\include 0000000001-start/01_prelude.up.sql
\include 0000000001-start/02_current_user_id_or_null.up.sql
\include 0000000001-start/03_current_user_id_required.up.sql
\include 0000000001-start/04_generate_url_safe_token.up.sql
\include 0000000001-start/05_jwt.up.sql
\include 0000000001-start/06_tg__set_updated_at.up.sql
\include 0000000001-start/07_rabbitmq.up.sql
\include 0000000001-start/08_validate_subscription.up.sql
\include 0000000001-start/09_is_between_0_and_100.up.sql
\include 0000000001-start/10_implication.up.sql


commit;

-- ==== DOWN ====

-- do nothing, this should never happen

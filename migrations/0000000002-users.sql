-- ====  UP  ====

begin;

\include 0000000002-users/01_entities/01_users/01_table.up.sql
\include 0000000002-users/01_entities/01_users/02_triggers.up.sql
\include 0000000002-users/01_entities/01_users/03_policies.up.sql
\include 0000000002-users/01_entities/01_users/04_computable_columns/01_full_name.up.sql
\include 0000000002-users/01_entities/02_user_oauths/01_table.up.sql
\include 0000000002-users/01_entities/02_user_oauths/02_triggers.up.sql
\include 0000000002-users/01_entities/02_user_oauths/03_policies.up.sql
\include 0000000002-users/02_utils/01_next_users_confirmation_token.up.sql
\include 0000000002-users/02_utils/02_next_users_reset_password_token.up.sql
\include 0000000002-users/03_queries/01_current_user.up.sql
\include 0000000002-users/04_actions/01_rabbitmq/01_send_confirmation_mail.up.sql
\include 0000000002-users/04_actions/01_rabbitmq/02_send_reset_password_mail.up.sql
\include 0000000002-users/04_actions/01_rabbitmq/03_send_welcome_mail.up.sql
\include 0000000002-users/04_actions/01_rabbitmq/04_send_password_was_changed_mail.up.sql
\include 0000000002-users/04_actions/02_register.up.sql
\include 0000000002-users/04_actions/03_login.up.sql
\include 0000000002-users/04_actions/04_login_or_register_oauth.up.sql
\include 0000000002-users/04_actions/05_confirm.up.sql
\include 0000000002-users/04_actions/06_resend_confirmation.up.sql
\include 0000000002-users/04_actions/07_send_reset_password.up.sql
\include 0000000002-users/04_actions/08_reset_password.up.sql


commit;

-- ==== DOWN ====

-- do nothing, this should never happen

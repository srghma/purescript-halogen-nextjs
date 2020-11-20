module PostgreSQLTruncateSchemas where

import Protolude

import Data.String as String
import Database.PostgreSQL as PostgreSQL

truncateSchemas :: PostgreSQL.Connection -> Array String -> Aff Unit
truncateSchemas connection schemas =
  PostgreSQL.execute connection
    (PostgreSQL.Query $ String.joinWith "\n"
      [ """
        DO
        $func$
        BEGIN
          EXECUTE
          (
            SELECT 'TRUNCATE TABLE ' || string_agg(format('%I.%I', table_schema, table_name), ', ') || ' RESTART IDENTITY CASCADE'
            FROM information_schema.tables
        """
      , "WHERE table_schema IN (" <> schemas' <> ")"
      , """
            AND table_type = 'BASE TABLE'
          );
        END
        $func$;
        """
      ]
    ) PostgreSQL.Row0
    >>= maybe (pure unit) throwPgError
  where
    schemas' = String.joinWith ", " $ map squote schemas

    squote x = "\'" <> x <> "\'"

    throwPgError e = throwError $ error $ "PgError when truncating table: " <> show e


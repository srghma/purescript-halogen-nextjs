module FeatureTests.FeatureTestSpecUtils.Db where

import Protolude

import Data.Exists (Exists)
import Data.Functor.Variant (FProxy(..))
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..))
import Database.PostgreSQL as PostgreSQL
import Run (Run)
import Run as Run
import Run.Except as Run
import Run.Reader (Reader(..))
import Run.Reader as Run

throwString :: ∀ t12 t13. String → Run ( effect ∷ FProxy Effect | t12 ) t13
throwString = error >>> throwError >>> Run.liftEffect

throwPgError :: ∀ t18 t19 t21. Show t21 ⇒ t21 → Run ( effect ∷ FProxy Effect | t19 ) t18
throwPgError e = throwString $ "PgError: " <> show e

----------

execute querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.execute config.dbConnection querySql values

executeOrThrow :: ∀ t131 t132 t133 t141. ToSQLRow t132 ⇒ Query t132 t133 → t132 → Run ( aff ∷ FProxy Aff , effect ∷ FProxy Effect , reader ∷ FProxy (Reader { dbConnection :: Connection | t131 } ) | t141 ) Unit
executeOrThrow querySql values = execute querySql values >>= maybe (pure unit) throwPgError

----------

query querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.query config.dbConnection querySql values

queryOrThrow :: ∀ t107 t96 t97 t98. ToSQLRow t97 ⇒ FromSQLRow t98 ⇒ Query t97 t98 → t97 → Run ( aff ∷ FProxy Aff , effect ∷ FProxy Effect , reader ∷ FProxy (Reader { dbConnection :: Connection | t96 } ) | t107 ) (Array t98)
queryOrThrow querySql values = query querySql values >>= either throwPgError pure

----------

scalar querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.scalar config.dbConnection querySql values

scalarOrThrow :: ∀ t45 t46 t47 t56. ToSQLRow t46 ⇒ FromSQLValue t47 ⇒ Query t46 (Row1 t47) → t46 → Run ( aff ∷ FProxy Aff , effect ∷ FProxy Effect , reader ∷ FProxy (Reader { dbConnection :: Connection | t45 } ) | t56 ) (Maybe t47)
scalarOrThrow querySql values = scalar querySql values >>= either throwPgError pure

scalarOrThrowRequired :: ∀ t61 t63 t65 t66. ToSQLRow t65 ⇒ FromSQLValue t61 ⇒ Query t65 (Row1 t61) → t65 → Run ( aff ∷ FProxy Aff , effect ∷ FProxy Effect , reader ∷ FProxy (Reader { dbConnection :: Connection | t66 } ) | t63 ) t61
scalarOrThrowRequired querySql values = scalarOrThrow querySql values >>= maybe (throwString "scalarOrThrowRequired: expected Just") pure

----------

command querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.command config.dbConnection querySql values

commandOrThrow :: ∀ t164 t165 t174. ToSQLRow t165 ⇒ Query t165 Int → t165 → Run ( aff ∷ FProxy Aff , effect ∷ FProxy Effect , reader ∷ FProxy (Reader { dbConnection :: Connection | t164 } ) | t174 ) Int
commandOrThrow querySql values = command querySql values >>= either throwPgError pure

-----------

-- | squote s = "'" <> s "'"

module FeatureTests.FeatureTestSpecUtils.Db where

import Protolude

import Control.Monad.Reader (ask)
import Data.Exists (Exists)
import Data.Functor.Variant (FProxy(..))
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..))
import Database.PostgreSQL as PostgreSQL

throwString :: ∀ t6 t7. MonadThrow Error t6 ⇒ String → t6 t7
throwString = error >>> throwError

throwPgError :: ∀ t12 t13 t15. MonadThrow Error t13 ⇒ Show t15 ⇒ t15 → t13 t12
throwPgError e = throwString $ "PgError: " <> show e

----------

execute
  :: ∀ i o m r
   . ToSQLRow i
  => MonadAsk { dbConnection :: Connection | r } m
  => MonadAff m
  => Query i o
  -> i
  -> m (Maybe PGError)
execute querySql values = ask >>= \config -> liftAff $ PostgreSQL.execute config.dbConnection querySql values

executeOrThrow :: ∀ t113 t116 t118 t119. Bind t113 ⇒ ToSQLRow t119 ⇒ MonadAsk { dbConnection :: Connection | t116 } t113 ⇒ MonadAff t113 ⇒ MonadThrow Error t113 ⇒ Query t119 t118 -> t119 -> t113 Unit
executeOrThrow querySql values = execute querySql values >>= maybe (pure unit) throwPgError

----------

query
  :: ∀ i o r m
   . ToSQLRow i
  => FromSQLRow o
  => MonadAsk { dbConnection :: Connection | r } m
  => MonadAff m
  => Query i o
  -> i
  -> m (Either PGError (Array o))
query querySql values = ask >>= \config -> liftAff $ PostgreSQL.query config.dbConnection querySql values

queryOrThrow :: ∀ t77 t81 t82 t83. Bind t77 ⇒ ToSQLRow t83 ⇒ FromSQLRow t82 ⇒ MonadAsk { dbConnection :: Connection | t81 } t77 ⇒ MonadAff t77 ⇒ MonadThrow Error t77 ⇒ Query t83 t82 → t83 → t77 (Array t82)
queryOrThrow querySql values = query querySql values >>= either throwPgError pure

----------

scalar :: ∀ i o r m. ToSQLRow i ⇒ FromSQLValue o => MonadAsk { dbConnection :: Connection | r } m => MonadAff m => Query i (Row1 o) → i → m (Either PGError (Maybe o))
scalar querySql values = ask >>= \config -> liftAff $ PostgreSQL.scalar config.dbConnection querySql values

scalarOrThrow :: ∀ t31 t35 t36 t37. Bind t31 ⇒ ToSQLRow t37 ⇒ FromSQLValue t36 ⇒ MonadAsk { dbConnection :: Connection | t35 } t31 ⇒ MonadAff t31 ⇒ MonadThrow Error t31 ⇒ Query t37 (Row1 t36) → t37 → t31 (Maybe t36)
scalarOrThrow querySql values = scalar querySql values >>= either throwPgError pure

scalarOrThrowRequired :: ∀ t49 t50 t52 t54. Bind t49 ⇒ ToSQLRow t52 ⇒ FromSQLValue t50 ⇒ MonadAsk { dbConnection :: Connection | t54 } t49 ⇒ MonadAff t49 ⇒ MonadThrow Error t49 ⇒ Query t52 (Row1 t50) → t52 → t49 t50
scalarOrThrowRequired querySql values = scalarOrThrow querySql values >>= maybe (throwString "scalarOrThrowRequired: expected Just") pure

----------

command :: ∀ i r m . ToSQLRow i => MonadAsk { dbConnection :: Connection | r } m => MonadAff m => Query i Int → i → m (Either PGError Int)
command querySql values = ask >>= \config -> liftAff $ PostgreSQL.command config.dbConnection querySql values

commandOrThrow :: ∀ t132 t136 t137. Bind t132 ⇒ ToSQLRow t137 ⇒ MonadAsk { dbConnection :: Connection | t136 } t132 ⇒ MonadAff t132 ⇒ MonadThrow Error t132 ⇒ Query t137 Int → t137 → t132 Int
commandOrThrow querySql values = command querySql values >>= either throwPgError pure

-----------

-- | squote s = "'" <> s "'"

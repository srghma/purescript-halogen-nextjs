module FeatureTests.FeatureTestSpecUtils.Db where

import Protolude

import Data.Exists (Exists)
import Data.Functor.Variant (FProxy(..))
import Database.PostgreSQL as PostgreSQL
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run

throwString = error >>> throwError >>> Run.liftEffect

throwPgError e = throwString $ "PgError: " <> show e

----------

execute querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.execute config.dbConnection querySql values

executeOrThrow querySql values = execute querySql values >>= maybe (pure unit) throwPgError

----------

query querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.query config.dbConnection querySql values

queryOrThrow querySql values = query querySql values >>= either throwPgError pure

----------

scalar querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.scalar config.dbConnection querySql values

scalarOrThrow querySql values = scalar querySql values >>= either throwPgError pure

scalarOrThrowRequired querySql values = scalarOrThrow querySql values >>= maybe (throwString "scalarOrThrowRequired: expected Just") pure

----------

command querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.command config.dbConnection querySql values

commandOrThrow querySql values = command querySql values >>= either throwPgError pure

-----------

-- | squote s = "'" <> s "'"

module FeatureTests.FeatureTestSpecUtils.Db where

import Protolude

import Data.Exists (Exists)
import Data.Functor.Variant (FProxy(..))
import Database.PostgreSQL as PostgreSQL
import Run (Run)
import Run as Run
import Run.Reader as Run

execute querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.execute config.dbConnection querySql values

query querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.query config.dbConnection querySql values

scalar querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.scalar config.dbConnection querySql values

command querySql values = Run.ask >>= \config -> Run.liftAff $ PostgreSQL.command config.dbConnection querySql values

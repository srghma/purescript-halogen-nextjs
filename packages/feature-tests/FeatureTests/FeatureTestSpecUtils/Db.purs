module FeatureTests.FeatureTestSpecUtils.Db where

import Protolude
import Run (Run)
import Run as Run
import Run.Reader as Run
import Database.PostgreSQL as PostgreSQL
import FeatureTests.FeatureTestSpec

-- | withTransaction :: Run FeatureTestRunEffects Unit -> Run FeatureTestRunEffects Unit
-- | withTransaction action =
-- |   Run.ask >>=
-- |   \config -> Run.liftAff $ PostgreSQL.withTransaction config.dbConnection (runFeatureTest action config)

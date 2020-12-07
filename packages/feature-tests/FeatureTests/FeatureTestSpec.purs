module FeatureTests.FeatureTestSpec where

import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Exception
import Protolude
import Unsafe.Coerce

import Control.Monad.Reader.Trans (runReaderT, ReaderT)
import Database.PostgreSQL as PostgreSQL
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd as DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.GoClientRoute as GoClientRoute
import Lunapark as Lunapark
import Node.ReadLine as Node.ReadLine
import PostgreSQLTruncateSchemas as PostgreSQLTruncateSchemas
import Test.Spec (SpecT(..))
import Test.Spec as Test.Spec

type FeatureTestEnv
  = { interpreter :: Lunapark.Interpreter ()
    , clientRootUrl :: String -- e.g. "http://localhost:3000"
    , readLineInterface :: Node.ReadLine.Interface
    , dbConnection :: PostgreSQL.Connection
    }

withTransactionOrThrow :: ∀ a. PostgreSQL.Connection -> Aff a → Aff a
withTransactionOrThrow dbConnection action = do
  (PostgreSQL.withTransaction dbConnection action) >>=
    either (\e -> throwError $ error $ "[withTransactionOrThrow] PgError: " <> show e) pure

withThuncateSchemas :: ∀ a. PostgreSQL.Connection -> Aff a → Aff a
withThuncateSchemas dbConnection action = do
  PostgreSQLTruncateSchemas.truncateSchemas dbConnection
    -- ordinary tables
    [ "app_public"
    , "app_private"
    , "app_hidden"
    -- truncate OR it will retry jobs on errors
    -- TODO: configure max_attempts from worker itself
    , "graphile_worker"
    ]
  action

-- SpecT monadOfExample exampleConfig monadOfSpec a

runFeatureTestWithEverythingElse spec = \config ->
  withThuncateSchemas config.dbConnection $
  runReaderT spec config

it :: String -> ReaderT FeatureTestEnv Aff Unit -> SpecT Aff FeatureTestEnv Identity Unit
it name spec = Test.Spec.it name $ runFeatureTestWithEverythingElse spec

itOnly :: String -> ReaderT FeatureTestEnv Aff Unit -> SpecT Aff FeatureTestEnv Identity Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTestWithEverythingElse spec

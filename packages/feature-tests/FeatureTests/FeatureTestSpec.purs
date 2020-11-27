module FeatureTests.FeatureTestSpec where

import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Exception
import Protolude
import Unsafe.Coerce
import RunCatchEffect as RunCatchEffect

import Database.PostgreSQL as PostgreSQL
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd as DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.GoClientRoute as GoClientRoute
import Lunapark as Lunapark
import Node.ReadLine as Node.ReadLine
import PostgreSQLTruncateSchemas as PostgreSQLTruncateSchemas
import Run (Run)
import Run as Run
import Run.Except (EXCEPT)
import Run.Except as Run
import Run.Reader as Run
import Test.Spec (SpecT(..))
import Test.Spec as Test.Spec

type FeatureTestConfig
  = { interpreter :: Lunapark.Interpreter ( catch  ∷ RunCatchEffect.CATCH Lunapark.Error )
    , clientRootUrl :: String -- e.g. "http://localhost:3000"
    , readLineInterface :: Node.ReadLine.Interface
    | ReaderEnvRow
    }

type ReaderEnvRow =
  ( dbConnection :: PostgreSQL.Connection
  )

type ReaderEnv = Record ReaderEnvRow

type FeatureTestRunEffects =
  ( GoClientRoute.GoClientRouteEffect
  + DebuggingAndTdd.PressEnterToContinueEffect
  + Lunapark.LunaparkEffect
  + Lunapark.ActionsEffect
  + ( reader ∷ Run.READER ReaderEnv
    , catch  ∷ RunCatchEffect.CATCH Lunapark.Error
    , except ∷ Run.EXCEPT Lunapark.Error
    , aff    ∷ Run.AFF
    , effect ∷ Run.EFFECT
    )
  )

runFeatureTestImplementation :: ∀ a . Run FeatureTestRunEffects a → FeatureTestConfig → Aff (Either Lunapark.Error a)
runFeatureTestImplementation spec config =
  Run.runBaseAff'
  $ RunCatchEffect.runCatch
  $ Lunapark.runInterpreter config.interpreter
  $ GoClientRoute.runGoClientRoute config.clientRootUrl
  $ DebuggingAndTdd.runPressEnterToContinue config.readLineInterface
  $ Run.runReader
    { dbConnection: config.dbConnection
    }
  $ spec

runFeatureTest :: ∀ a . Run FeatureTestRunEffects a → FeatureTestConfig → Aff a
runFeatureTest spec config = runFeatureTestImplementation spec config >>=
  either
  (\e -> throwError $ error $ "[runFeatureTest] Lunapark error: " <> Lunapark.printError e)
  pure

withTransactionOrThrow :: ∀ a. PostgreSQL.Connection -> Aff a → Aff a
withTransactionOrThrow dbConnection action = do
  (PostgreSQL.withTransaction dbConnection action) >>=
    either (\e -> throwError $ error $ "[withTransactionOrThrow] PgError: " <> show e) pure

withThuncateSchemas :: ∀ a. PostgreSQL.Connection -> Aff a → Aff a
withThuncateSchemas dbConnection action = do
  PostgreSQLTruncateSchemas.truncateSchemas dbConnection ["app_public", "app_private", "app_hidden"]
  action

-- SpecT monadOfExample exampleConfig monadOfSpec a

-- | runFeatureTestWithEverythingElse :: Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
runFeatureTestWithEverythingElse spec = \config ->
  withThuncateSchemas config.dbConnection $
  runFeatureTest spec config

it :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
it name spec = Test.Spec.it name $ runFeatureTestWithEverythingElse spec

itOnly :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTestWithEverythingElse spec

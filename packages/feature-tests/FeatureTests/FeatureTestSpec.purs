module FeatureTests.FeatureTestSpec where

import Protolude
import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Exception
import Test.Spec (SpecT(..))
import Test.Spec as Test.Spec
import Unsafe.Coerce
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run
import Lunapark as Lunapark
import Node.ReadLine as Node.ReadLine
import FeatureTests.FeatureTestSpecUtils.GoClientRoute as GoClientRoute
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd as DebuggingAndTdd
import Database.PostgreSQL as PostgreSQL

type FeatureTestConfig
  = { interpreter :: Lunapark.Interpreter ()
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
  + Lunapark.LunaparkActionsEffect
  + Lunapark.LunaparkBaseEffects
  + ( reader ∷ Run.READER ReaderEnv
    )
  )

runFeatureTestImplementation :: ∀ a . Run FeatureTestRunEffects a → FeatureTestConfig → Aff (Either Lunapark.Error a)
runFeatureTestImplementation spec config =
  Run.runBaseAff'
  $ Run.runExcept
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
  (\e -> throwError $ error $ "Error when running test: " <> Lunapark.printError e)
  pure

-- SpecT monadOfExample exampleConfig monadOfSpec a

it :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
it name spec = Test.Spec.it name $ runFeatureTest spec

runWithTransaction spec = \config -> do
  (PostgreSQL.withTransaction config.dbConnection $ runFeatureTest spec config) >>=
    either (\e -> throwError $ error $ show e) pure

itWithTransaction :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
itWithTransaction name spec = Test.Spec.it name (runWithTransaction spec)

itOnly :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTest spec

itOnlyWithTransaction :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
itOnlyWithTransaction name spec = Test.Spec.itOnly name (runWithTransaction spec)

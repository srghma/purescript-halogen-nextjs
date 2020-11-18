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
import Database.PostgreSQL.PG (defaultPoolConfiguration, PGError, command, execute, newPool, Pool, Connection, query, Query(Query))
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run
import Lunapark as Lunapark
import Node.ReadLine as Node.ReadLine

type FeatureTestConfig
  = { interpreter :: Lunapark.Interpreter
      ( reader ∷ Run.READER ReaderEnv
      )
    | ReaderEnvRow
    }

type ReaderEnvRow =
  ( readLineInterface :: Node.ReadLine.Interface
  , clientRootUrl :: String -- e.g. "http://localhost:3000"
  )

type ReaderEnv = Record ReaderEnvRow

type FeatureTestRunEffects =
  ( lunapark        ∷ Lunapark.LUNAPARK
  , lunaparkActions ∷ Lunapark.LUNAPARK_ACTIONS
  , except          ∷ Run.EXCEPT Lunapark.Error
  , aff             ∷ Run.AFF
  , effect          ∷ Run.EFFECT
  , reader          ∷ Run.READER ReaderEnv
  )

runFeatureTestImplementation :: ∀ a . Run FeatureTestRunEffects a → FeatureTestConfig → Aff (Either Lunapark.Error a)
runFeatureTestImplementation spec config =
  Run.runBaseAff'
  $ Run.runExcept
  $ Run.runReader
    { readLineInterface: config.readLineInterface
    , clientRootUrl: config.clientRootUrl
    }
  $ Lunapark.runInterpreter config.interpreter spec

runFeatureTest :: ∀ a . Run FeatureTestRunEffects a → FeatureTestConfig → Aff a
runFeatureTest spec config = runFeatureTestImplementation spec config >>=
  either
  (\e -> throwError $ error $ "Error when running test: " <> Lunapark.printError e)
  pure

-- SpecT monadOfExample exampleConfig monadOfSpec a
it :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
it name spec = Test.Spec.it name $ runFeatureTest spec

itOnly :: String -> Run FeatureTestRunEffects Unit -> SpecT Aff FeatureTestConfig Identity Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTest spec

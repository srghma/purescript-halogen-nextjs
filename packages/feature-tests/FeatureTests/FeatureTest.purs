module FeatureTests.FeatureTest where

import Prelude
import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Data.Maybe
import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import Selenium.Browser
import Selenium.Builder
import Selenium.Monad
import Selenium.Types
import Test.Spec (SpecT(..))
import Test.Spec as Test.Spec
import Unsafe.Coerce
import Database.PostgreSQL.PG (defaultPoolConfiguration, PGError, command, execute, newPool, Pool, Connection, query, Query(Query))
import Lib.BuildSeleniumChromeDriver

defaultTimeout :: Milliseconds
defaultTimeout = Milliseconds 50.0

type FeatureTestConfig
  = { defaultTimeout ∷ Milliseconds
    , driver ∷ Driver
    , connection :: Connection
    }

type FeatureTestSpecInternal a
  = SpecT Aff FeatureTestConfig Identity a

type FeatureTestSpec a
  = ReaderT FeatureTestConfig Aff a

-- SpecT monadOfExample exampleConfig monadOfSpec a
runFeatureTest :: ∀ m a. ReaderT FeatureTestConfig m a → FeatureTestConfig → m a
runFeatureTest = runReaderT

it :: String -> FeatureTestSpec Unit -> FeatureTestSpecInternal Unit
it name spec = Test.Spec.it name $ runFeatureTest spec

itOnly :: String -> FeatureTestSpec Unit -> FeatureTestSpecInternal Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTest spec

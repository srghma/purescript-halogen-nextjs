module FeatureTests.FeatureTestSpec where

import Protolude
import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
-- | import Selenium.Browser
-- | import Selenium.Builder
-- | import Selenium.Monad
-- | import Selenium.Types
import Test.Spec (SpecT(..))
import Test.Spec as Test.Spec
import Unsafe.Coerce
import Database.PostgreSQL.PG (defaultPoolConfiguration, PGError, command, execute, newPool, Pool, Connection, query, Query(Query))
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run
import Lunapark as Lunapark

defaultTimeout :: Milliseconds
defaultTimeout = Milliseconds 50.0

type FeatureTestConfig
  = { clientRootUrl :: String -- e.g. "http://localhost:3000"
    -- connection :: Connection
    -- | , driver ∷ Driver
    -- | , timeout ∷ Milliseconds
    }

type FeatureTestSpec a
  = Run
    -- | ( reader          ∷ Run.READER
    -- |   { clientRootUrl :: String -- e.g. "http://localhost:3000"
    -- |   }
    ( lunapark        ∷ Lunapark.LUNAPARK
    , lunaparkActions ∷ Lunapark.LUNAPARK_ACTIONS
    , except          ∷ Run.EXCEPT Lunapark.Error
    , aff             ∷ Run.AFF
    , effect          ∷ Run.EFFECT
    )
    a

-- SpecT monadOfExample exampleConfig monadOfSpec a
runFeatureTest :: ∀ a. FeatureTestSpec a → FeatureTestConfig → Aff a
runFeatureTest = undefined

it :: String -> FeatureTestSpec Unit -> SpecT Aff FeatureTestConfig Identity Unit
it name spec = Test.Spec.it name $ runFeatureTest spec

itOnly :: String -> FeatureTestSpec Unit -> SpecT Aff FeatureTestConfig Identity Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTest spec

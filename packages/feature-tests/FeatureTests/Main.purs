module FeatureTests.Main where

import Prelude
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (launchAff_, delay)
import Test.Spec (pending, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner
import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception as Effect.Exception
import Prelude
import Test.Spec
import Unsafe.Coerce
import Data.Identity
import Data.Foldable
import Control.Monad.Except.Trans (ExceptT, runExceptT)
import Database.PostgreSQL as Database.PostgreSQL
import Database.PostgreSQL (ConnectResult, PoolConfiguration, Pool)
import Database.PostgreSQL.Row (Row0(..), Row3(..))
import Data.Decimal as Decimal
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Effect.Aff
import Effect.Aff as Effect.Aff
import Effect.Class (liftEffect)
import Effect.Aff.AVar as Effect.Aff.AVar
import Effect.AVar (AVar)
import Node.Process
import Foreign.Object
import Data.Either
import Data.Int as Data.Int
import Control.Monad.Error.Class (throwError)
import Effect.Exception (error)
import Effect.Now (nowDateTime)
import Data.DateTime (Time, diff)
import Data.Time.Duration (class Duration)
import Debug.Trace (traceM)
import Control.Parallel
import SpecAroundAll
import FeatureTests.FeatureTestSpec
import FeatureTests.AllTests
import FeatureTests.Config as Config

connectToDb :: PoolConfiguration -> Aff ConnectResult
connectToDb poolConfiguration = do
  pool :: Pool <- liftEffect $ Database.PostgreSQL.newPool poolConfiguration
  connectionResult :: ConnectResult <- Database.PostgreSQL.connect pool >>= either (show >>> error >>> throwError) pure
  pure connectionResult

main :: Effect Unit
main =
  launchAff_ do
    config <- liftEffect Config.config

    connectionResult <- connectToDb
      { database:          config.databaseName
      , host:              Just config.databaseHost
      , idleTimeoutMillis: Nothing
      , max:               Nothing
      , password:          Just config.databaseOwnerPassword
      , port:              config.databasePort
      , user:              Just config.databaseOwnerUser
      }

    let
      testsConfig =
        { clientRootUrl: config.clientRootUrl
        -- | , connection: connectionResult.connection
        -- | , driver
        -- | , defaultTimeout
        }
    runSpec' (defaultConfig { timeout = Nothing }) [ consoleReporter ]
      ( before (pure testsConfig)
        $ afterAll_ (liftEffect $ connectionResult.done)
        $ allTests
      )

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
import Lunapark as Lunapark
import Lunapark.Types as Lunapark
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run
import Node.ReadLine as Node.ReadLine

connectToDb :: PoolConfiguration -> Aff ConnectResult
connectToDb poolConfiguration = do
  pool :: Pool <- liftEffect $ Database.PostgreSQL.newPool poolConfiguration
  connectionResult :: ConnectResult <- Database.PostgreSQL.connect pool >>= either (show >>> error >>> throwError) pure
  pure connectionResult

readQuestionStdin :: String -> Aff String
readQuestionStdin question = makeAff \callback -> do
  interface <- Node.ReadLine.createConsoleInterface Node.ReadLine.noCompletion
  Node.ReadLine.question
    question
    (\s -> do
      traceM $ "input " <> s
      Node.ReadLine.close interface
      callback $ Right s
    )
    interface
  pure $ effectCanceler $ Node.ReadLine.close interface

pressCtrlDToContinue :: Aff Unit
pressCtrlDToContinue = void $ readQuestionStdin "Press \"CTRL-D\" to continue: "

main :: Effect Unit
main = do
  interface <- Node.ReadLine.createConsoleInterface Node.ReadLine.noCompletion

  launchAff_ do
    pressCtrlDToContinue

    config <- liftEffect Config.config

    (interpreter :: Lunapark.Interpreter ()) <- Lunapark.init config.chromedriverUrl
      { alwaysMatch:
        -- based on https://www.w3.org/TR/webdriver1/ "Example 5"
        -- chrome:browserOptions
        [ Lunapark.CustomCapability "goog:chromeOptions" $ unsafeCoerce
          { "binary": config.chromeBinaryPath
          -- | , "debuggerAddress": "127.0.0.1:9222"
          , "args":
            -- disable chrome's wakiness
            [ "--disable-infobars"
            , "--disable-extensions"

            -- allow http
            , "--disable-web-security"

            -- other
            , "--lang=en"
            , "--no-default-browser-check"
            , "--no-sandbox"

            -- not working
            , "--start-maximized"
            ]
          , "prefs":
            -- disable chrome's annoying password manager
            { "profile.password_manager_enabled": false
            , "credentials_enable_service":         false
            , "password_manager_enabled":           false
            , "download":
              { "default_directory":   config.remoteDownloadDirPath
              , "prompt_for_download": false
              , "directory_upgrade":   true
              , "extensions_to_open":  ""
              }
            , "plugins": { "plugins_disabled": ["Chrome PDF Viewer"] } -- disable viewing pdf files after download
            }
          }
        ]
      , firstMatch:
        [ [ Lunapark.BrowserName Lunapark.Chrome
          ]
        ]
      }
      >>=
        either
        (\e -> throwError $ error $ "An error during selenium session initialization occured: " <> Lunapark.printError e)
        pure

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
        , interpreter
        }
    runSpec' (defaultConfig { timeout = Nothing }) [ consoleReporter ]
      ( before (pure testsConfig)
        $ afterAll_ do
           liftEffect $ connectionResult.done

           ( Run.runBaseAff'
           $ Run.runExcept
           $ Lunapark.runInterpreter interpreter Lunapark.quit
           ) >>=
             either
             (\e -> throwError $ error $ "Error when quitting: " <> Lunapark.printError e)
             pure
        $ allTests
      )

module FeatureTests.login.error-not-confirmed-spec where

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
import Test.Spec
import Unsafe.Coerce
import Lib.BuildSeleniumChromeDriver
import Lib.FeatureTest

spec :: FeatureTestSpec Unit
spec = pure unit

module FeatureTests.Login.SuccessSpec where

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
import Lib.BuildMyDriver
import Lib.FeatureTest
import Lib.Helpers

spec :: FeatureTestSpec Unit
spec = do
  getClientSite "/"
  stop

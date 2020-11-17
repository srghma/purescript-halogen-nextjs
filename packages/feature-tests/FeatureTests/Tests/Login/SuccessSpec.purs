module FeatureTests.Tests.Login.SuccessSpec where

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
import Test.Spec
import Unsafe.Coerce
import FeatureTests.FeatureTestSpec
import Run (Run)
import Lunapark as Lunapark

spec :: Run FeatureTestRunEffects Unit
spec = do
  Lunapark.go "http://my-site.com"

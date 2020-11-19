module FeatureTests.Tests.Login.SuccessSpec where

import Protolude
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
import Run as Run
import Run.Reader as Run
import Lunapark as Lunapark
import Lunapark.Types as Lunapark
import Node.Process as Node.Process
import Node.Encoding as Node.Encoding
import Node.Stream as Node.Stream
import Effect.Ref as Ref
import Control.Monad.Rec.Class
import Node.ReadLine as Node.ReadLine
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.GoClientRoute
import NextjsApp.Route
import Database.PostgreSQL

inputField locator s = do
  element ← Lunapark.findElement locator
  Lunapark.clearElement element
  -- | Lunapark.moveTo { origin: Lunapark.FromElement element, x: 0, y: 0, duration: Milliseconds 1000.0 }
  -- | Lunapark.click
  Lunapark.sendKeysElement element s

spec :: Run FeatureTestRunEffects Unit
spec = do
  execute (Query """
    INSERT INTO app_public.users (username)
    VALUES ($1)
  """) (Row1 "pork" true (D.fromString "8.30"))

  goClientRoute Login
  -- | inputField (Lunapark.ByXPath """//form//input[@aria-labelledby="usernameOrEmail"]""") "asdf"
  -- | inputField (Lunapark.ByXPath """//form//input[@aria-labelledby="password"]""") "qwe"
  -- | pressEnterToContinue

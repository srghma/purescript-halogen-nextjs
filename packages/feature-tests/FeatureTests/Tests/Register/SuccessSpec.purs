module FeatureTests.Tests.Register.SuccessSpec where

import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Control.Monad.Rec.Class
import Data.Identity
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import FeatureTests.FeatureTestSpec
import FeatureTests.FeatureTestSpecUtils.Db
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.GoClientRoute
import LunaparkExtra
import NextjsApp.Route
import Protolude
import Test.Spec
import Unsafe.Coerce
import FeatureTests.FeatureTestSpecUtils.AffRetry

import CSS as CSS
import CSS.Elements as CSS.Elements
import Data.String (Pattern(..), contains)
import Database.PostgreSQL as PostgreSQL
import Effect.Aff.Retry as AffRetry
import Effect.Ref as Ref
import Faker as Faker
import Faker.Lorem as Faker.Lorem
import Faker.Name as Faker.Name
import FeatureTests.FeatureTestSpecUtils.Lunapark (runLunapark)
import Lunapark as Lunapark
import Lunapark.Endpoint (EndpointPart(..))
import Lunapark.Types as Lunapark
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Run (Run)
import Run as Run
import Run.Except as Run
import Run.Reader as Run
import Test.Spec.Assertions (fail, shouldContain, shouldEqual)
import SpecAssertsExtra

usernameOrEmailXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="usernameOrEmail"]"""

passwordXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="password"]"""

spec :: ReaderT FeatureTestEnv Aff Unit
spec = do
  let
    user =
      { username: "username1"
      , password: "userpassword1"
      , email: "useremail1@mail.com"
      }

  goClientRoute Register

  pressEnterToContinue

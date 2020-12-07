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
import FeatureTests.FeatureTestSpec
import FeatureTests.FeatureTestSpecUtils.AffRetry
import FeatureTests.FeatureTestSpecUtils.Db
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.GoClientRoute
import FeatureTests.FeatureTestSpecUtils.LunaparkUtils
import LunaparkExtra
import NextjsApp.Route
import Protolude
import SpecAssertsExtra
import Test.Spec
import Unsafe.Coerce

import CSS as CSS
import CSS.Elements as CSS.Elements
import Data.Argonaut as Json
import Data.Argonaut.Decode as Json
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

usernameXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="username"]"""

emailXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="email"]"""

passwordXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="password"]"""

passwordConfirmationXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="passwordConfirmation"]"""

spec :: ReaderT FeatureTestEnv Aff Unit
spec = do
  let
    user =
      { username: "username1"
      , password: "userpassword1"
      , email: "useremail1@mail.com"
      }

  goClientRoute Register

  runLunapark $ inputField usernameXpath user.username
  waitForInputValueToEqual usernameXpath user.username

  runLunapark $ inputField emailXpath user.email
  waitForInputValueToEqual emailXpath user.email

  runLunapark $ inputField passwordXpath user.password
  waitForInputValueToEqual passwordXpath user.password

  runLunapark $ inputField passwordConfirmationXpath user.password
  waitForInputValueToEqual passwordConfirmationXpath user.password

  -- TODO: inputtig second time because of some ...
  runLunapark $ inputField usernameXpath user.username
  waitForInputValueToEqual usernameXpath user.username

  ( runLunapark $
    (Lunapark.findElement $ Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""")
    >>= \element -> Lunapark.getProperty element "disabled"
  ) >>= \json -> do
     boolean <- (Json.decodeJson json :: Either Json.JsonDecodeError Boolean) # either (throwError <<< error <<< Json.printJsonDecodeError) pure
     boolean `shouldEqual` false

  runLunapark $
    Lunapark.findElement (Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""")
    >>= Lunapark.clickElement

  -- TODO: hack, probalby because it is still validating
  void $ try $ runLunapark $
    Lunapark.findElement (Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""")
    >>= Lunapark.clickElement

  retryAction $
    ( getCurrentRoute
      >>= \mRoute -> mRoute `shouldEqual` Just Secret
    )

  ( runLunapark $
    (Lunapark.findElement $ Lunapark.ByCss $ CSS.Elements.body)
    >>= Lunapark.getText
  ) >>= \text -> text `shouldContainString` Pattern "You are on secret page"

  -- TODO: email is received

  pressEnterToContinue

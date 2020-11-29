module FeatureTests.Tests.Login.SuccessSpec where

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

import CSS as CSS
import Database.PostgreSQL as PostgreSQL
import Effect.Aff.Retry as AffRetry
import Effect.Ref as Ref
import Faker as Faker
import Faker.Lorem as Faker.Lorem
import Faker.Name as Faker.Name
import FeatureTests.FeatureTestSpecUtils.Lunapark (runLunapark)
import Lunapark as Lunapark
import Lunapark.Types as Lunapark
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Run (Run)
import Run as Run
import Run.Except as Run
import Run.Reader as Run
import Test.Spec.Assertions (shouldEqual)

retryAction action =
  AffRetry.recovering
    (AffRetry.constantDelay (Milliseconds 200.0) <> AffRetry.limitRetries 10)
    [\_ _ -> pure true]
    (\_ -> spy "retrying" action)

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

  (newUserId :: String) <- scalarOrThrowRequired (PostgreSQL.Query """
      INSERT INTO app_public.users (username)
      VALUES ($1) RETURNING id as new_user_id;
  """) (PostgreSQL.Row1 user.username)

  executeOrThrow (PostgreSQL.Query """
      UPDATE app_private.user_secrets
      SET password_hash = crypt($2, gen_salt('bf'))
      WHERE user_id = $1;
  """) (PostgreSQL.Row2 newUserId user.password)

  executeOrThrow (PostgreSQL.Query """
      INSERT INTO app_hidden.user_emails (user_id, email, is_verified)
      VALUES ($1, $2, true)
  """) (PostgreSQL.Row2 newUserId user.email)

  goClientRoute Login

  runLunapark $ inputField usernameOrEmailXpath "unknown@mail.com"

  ( retryAction $ runLunapark $
    (Lunapark.findElement $ Lunapark.ByCss $ CSS.Selector (CSS.Refinement [CSS.Id "usernameOrEmail-helper"]) CSS.Star)
    >>= Lunapark.getText
  ) >>= \text -> text `shouldEqual` "Username or email is not found"

  runLunapark $ inputField usernameOrEmailXpath user.email
  runLunapark $ inputField passwordXpath user.password

  retryAction $
    ( ( runLunapark $
        Lunapark.findElement passwordXpath
        >>= \e -> Lunapark.getAttribute e "value"
      )
      >>= \text -> text `shouldEqual` user.password
    )

  runLunapark $ Lunapark.findElement (Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""") >>= Lunapark.clickElement

  pressEnterToContinue

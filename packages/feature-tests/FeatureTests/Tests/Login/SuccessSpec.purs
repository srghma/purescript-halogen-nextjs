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
import FeatureTests.FeatureTestSpecUtils.Db
import NextjsApp.Route
import Database.PostgreSQL as PostgreSQL
import Faker as Faker
import Faker.Name as Faker.Name
import Faker.Lorem as Faker.Lorem

inputField locator s = do
  element ← Lunapark.findElement locator
  Lunapark.clearElement element
  -- | Lunapark.moveTo { origin: Lunapark.FromElement element, x: 0, y: 0, duration: Milliseconds 1000.0 }
  -- | Lunapark.click
  Lunapark.sendKeysElement element s

spec :: Run FeatureTestRunEffects Unit
spec = do
  -- | (Faker.Name.Name username) <- Run.liftEffect Faker.fake
  -- | (Faker.Lorem.Words password) <- Run.liftEffect Faker.fake

  let
    username = "username1"

    password = "userpassword1"

    email = "useremail1@mail.com"

  executeOrThrow (PostgreSQL.Query """
    INSERT INTO app_public.users (username)
    VALUES ($1) RETURNING new_user;

    INSERT INTO app_private.user_secrets (user_id, password_hash)
    VALUES (new_user.id, crypt($2, gen_salt('bf')));

    INSERT INTO app_public.users_emails (user_id, email, is_verified)
    VALUES (new_user.id, $3, true);
  """) (PostgreSQL.Row3 username password email)

  goClientRoute Login
  inputField (Lunapark.ByXPath """//form//input[@aria-labelledby="usernameOrEmail"]""") email
  inputField (Lunapark.ByXPath """//form//input[@aria-labelledby="password"]""") password
  pressEnterToContinue

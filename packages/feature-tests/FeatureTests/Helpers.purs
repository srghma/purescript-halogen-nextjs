module FeatureTests.Helpers where

import Prelude
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Database.PostgreSQL
import Data.Either
import Data.Array
import Lib.LookupEnv
import Selenium.Monad
import Effect.Class

getClientSite :: ∀ e o. String -> Selenium e o Unit
getClientSite url = liftEffect (lookupEnvValue "CLIENT_URL") >>= \base -> get (base <> url)


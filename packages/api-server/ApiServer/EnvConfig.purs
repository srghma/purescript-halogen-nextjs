module ApiServer.EnvConfig where

import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Env as Env
import Foreign.Object (Object)

type EnvConfig =
  { sessionSecret :: NonEmptyString
  , databaseOwnerPassword :: NonEmptyString
  , databaseAuthenticatorPassword :: NonEmptyString
  , oauthGithubClientSecret :: NonEmptyString
  }

envConfig :: Effect EnvConfig
envConfig = Env.parse Env.defaultInfo $
  { sessionSecret: _, databaseOwnerPassword: _, databaseAuthenticatorPassword: _, oauthGithubClientSecret: _ }
  <$> Env.var Env.nonEmptyString "sessionSecret" (Env.defaultVar { sensitive = true })
  <*> Env.var Env.nonEmptyString "databaseOwnerPassword" (Env.defaultVar { sensitive = true })
  <*> Env.var Env.nonEmptyString "databaseAuthenticatorPassword" (Env.defaultVar { sensitive = true })
  <*> Env.var Env.nonEmptyString "oauthGithubClientSecret" (Env.defaultVar { sensitive = true })

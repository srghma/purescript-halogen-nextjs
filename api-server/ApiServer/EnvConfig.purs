module ApiServer.EnvConfig where

import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Env as Env
import Foreign.Object (Object)

type EnvConfig =
  { jwtSecret :: NonEmptyString
  }

envConfig :: Effect EnvConfig
envConfig = Env.parse Env.defaultInfo $
  { jwtSecret: _ }
  <$> Env.var (Env.nonEmptyString) "JWT_SECRET" (Env.defaultVar { help = Just "JWT secret", sensitive = true })

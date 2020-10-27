module ApiServer.SecretConfig where

import Protolude
import Foreign.Object (Object)

-- from envs
type SecretConfig =
  { jwtSecret :: String
  }

readConfig :: Object String -> Either String Config
readConfig env = { greeting: _, count: _ }
  <$> value "GREETING"
  <*> (value "COUNT" >>= Int.fromString >>> note "Invalid COUNT")
  where
    value name =
      note ("Missing variable " <> name) $ lookup name env

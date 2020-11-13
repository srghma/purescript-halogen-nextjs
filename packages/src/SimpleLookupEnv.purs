module SimpleLookupEnv where

import Prelude
import Data.Maybe
import Data.Int as Data.Int
import Effect.Class
import Control.Monad.Error.Class
import Effect.Exception
import Node.Process
import Effect

lookupEnvValue :: String -> Effect String
lookupEnvValue name = lookupEnv name >>= maybe (throw $ "Missing environment variable " <> name) pure

lookupEnvValueInt :: String -> Effect Int
lookupEnvValueInt name = lookupEnvValue name >>= (\string -> (pure $ Data.Int.fromString string) >>= maybe (throw $ "Invalid " <> name <> ": expected valid integer but got " <> string) pure)

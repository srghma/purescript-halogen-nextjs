module ApiServer.Main where

import Prelude hiding (apply)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Response (send)
import Node.HTTP (Server)

data ConfigTarget
  = Production
  | Development
    { exportGqlSchemaPath  :: Pathy Abs File
    , exportJsonSchemaPath :: Pathy Abs File
    }

-- from args
type Config =
  { port          :: Int
  , host          :: String
  , databaseUrl   :: String
  , exposedSchema :: String
  , target        :: ConfigTarget
  }

-- from envs
type SecretConfig =
  { jwtSecret :: String
  }

app :: App
app = get "/" $ send "Hello, World!"

main :: Effect Server
main = do
  listenHttp app 8080 \_ ->
    log $ "Listening on " <> show 8080

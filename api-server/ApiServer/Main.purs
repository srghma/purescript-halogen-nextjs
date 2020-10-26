module ApiServer.Main where

import Prelude hiding (apply)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Response (send)
import Node.HTTP (Server)
import Pathy (Path, Abs, File, Dir)

data ConfigTarget
  = Production
  | Development
    { exportGqlSchemaPath  :: Path Abs File
    , exportJsonSchemaPath :: Path Abs File
    }

-- from args
type Config =
  { port          :: Int
  , host          :: String
  , databaseUrl   :: String
  , exposedSchema :: String
  , target        :: ConfigTarget
  }

app :: App
app = get "/" $ send "Hello, World!"

main :: Effect Server
main = do
  listenHttp app 8080 \_ ->
    log $ "Listening on " <> show 8080

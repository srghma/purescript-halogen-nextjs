module ApiServer.Main where

import Data.Maybe
import Pathy
import Protolude

import ApiServer.Config as ApiServer.Config
import Control.Monad.Error.Class (throwError)
import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Effect (Effect)
import Effect.Console (log)
import Env as Env
import Node.Express.App as Express
import Node.Express.Response as Express
import Options.Applicative as Options.Applicative

app :: Express.App
app = Express.get "/" $ Express.send "Hello, World!"

main :: Effect Unit
main = do
  config <- ApiServer.Config.config

  void $ Express.listenHttp app 8080 \_ ->
    log $ "Listening on " <> show 8080

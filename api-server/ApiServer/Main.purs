module ApiServer.Main where

import Data.Maybe
import Pathy
import Protolude

import ApiServer.Config as ApiServer.Config
import ApiServer.DatabasePools as ApiServer.DatabasePools
import ApiServer.Passport as ApiServer.Passport
import ApiServer.SessionMiddleware as ApiServer.SessionMiddleware
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

  pools <- ApiServer.DatabasePools.createPools
    { databaseName:                  config.databaseName
    , databaseHost:                  config.databaseHost
    , databasePort:                  config.databasePort
    , databaseOwnerUser:             config.databaseOwnerUser
    , databaseOwnerPassword:         config.databaseOwnerPassword
    , databaseAuthenticatorUser:     config.databaseAuthenticatorUser
    , databaseAuthenticatorPassword: config.databaseAuthenticatorPassword
    }

  sessionMiddleware <- ApiServer.SessionMiddleware.sessionMiddleware
    { target:        config.target
    , rootPgPool:    pools.rootPgPool
    , sessionSecret: config.sessionSecret
    }

  passportMiddlewareAndRoutes <- ApiServer.Passport.passportMiddlewareAndRoutes
    { oauthGithubClientId:     config.oauthGithubClientId
    , oauthGithubClientSecret: config.oauthGithubClientSecret
    , rootUrl:                 config.rootUrl
    }

  -- TODO: enhanceHttpServerWithSubscriptions
  httpServer <- Express.listenHttp app 8080 \_ ->
    log $ "Listening on " <> show 8080

  pure unit

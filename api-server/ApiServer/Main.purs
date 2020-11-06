-- | !!!!
-- | THIS IS IMPLEMENTED BASED ON
-- | https://github.com/graphile/bootstrap-react-apollo/tree/master/server/middleware

module ApiServer.Main where

import Data.Maybe
import Effect.Uncurried
import Pathy
import Protolude

import ApiServer.Config as ApiServer.Config
import ApiServer.DatabasePools as ApiServer.DatabasePools
import ApiServer.Passport as ApiServer.Passport
import ApiServer.Postgraphile as ApiServer.Postgraphile
import ApiServer.SessionMiddleware as ApiServer.SessionMiddleware
import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Effect (Effect)
import Effect.Console (log)
import Env as Env
import Node.Express.App (useExternal)
import Node.Express.App as Express
import Node.Express.Response as Express
import Options.Applicative as Options.Applicative
import Postgraphile as Postgraphile
import Node.HTTP as Node.HTTP

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
    { oauthGithubClientID:     config.oauthGithubClientID
    , oauthGithubClientSecret: config.oauthGithubClientSecret
    , rootUrl:                 config.rootUrl
    }

  let middlewares = [sessionMiddleware] <> passportMiddlewareAndRoutes.middlewares

  let postgraphileMiddleware = ApiServer.Postgraphile.mkMiddleware
        { authPgPool:            pools.authPgPool
        , rootPgPool:            pools.rootPgPool
        , websocketMiddlewares:  middlewares
        , target:                config.target
        , databaseName:          config.databaseName
        , databaseHost:          config.databaseHost
        , databasePort:          config.databasePort
        , databaseOwnerUser:     config.databaseOwnerUser
        , databaseOwnerPassword: config.databaseOwnerPassword
        }

  expressApp <- Express.mkApplication

  flip Express.apply expressApp do
     for_ (middlewares <> [postgraphileMiddleware]) Express.useExternal

  httpServer <- Express._httpServer expressApp

  runEffectFn2 Postgraphile.enhanceHttpServerWithSubscriptions httpServer postgraphileMiddleware

  Node.HTTP.listen
    httpServer
    { backlog: Nothing
    , hostname: config.hostname
    , port: config.port
    }
    do
      log $ "Listening on " <> config.hostname <> ":" <> show config.port <> ", public url " <> config.rootUrl

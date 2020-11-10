module ApiServer.Config where

import Data.Maybe
import Pathy
import Protolude

import ApiServer.DatabasePools as ApiServer.DatabasePools
import ApiServer.Passport as ApiServer.Passport
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
import ApiServer.CliConfig as ApiServer.CliConfig
import ApiServer.EnvConfig as ApiServer.EnvConfig

type DevelopmentConfig =
  { exportGqlSchemaPath  :: AnyFile
  , exportJsonSchemaPath :: AnyFile
  , clientPort :: Int
  }

data ConfigTarget
  = Production
  | Development DevelopmentConfig

-- from args
type Config =
  { target       :: ConfigTarget

  -- listen to, before the proxy
  , port         :: Int    -- e.g. "3000"
  , hostname         :: String -- e.g. "127.0.0.1", N.B. host is hostname + port

  -- for callbackURL, after the proxy
  , rootUrl :: String -- e.g. "http://mysite"

  , databaseName :: String
  , databaseHost :: String
  , databasePort :: Maybe Int
  , databaseOwnerUser             :: String
  , databaseOwnerPassword         :: NonEmptyString
  , databaseAuthenticatorUser     :: String
  , databaseAuthenticatorPassword :: NonEmptyString
  , databaseVisitorUser     :: String

  , oauthGithubClientID     :: String
  , oauthGithubClientSecret :: NonEmptyString

  , sessionSecret             :: NonEmptyString
  }

config :: Effect Config
config = do
  cliConfig <- Options.Applicative.execParser ApiServer.CliConfig.opts
  envConfig <- ApiServer.EnvConfig.envConfig

  target <-
    if cliConfig.isProdunction
      then pure Production
      else do
        let
            (developmentConfigTarget :: Maybe DevelopmentConfig) =
              { exportGqlSchemaPath: _
              , exportJsonSchemaPath: _
              , clientPort: _
              }
              <$> cliConfig.exportGqlSchemaPath
              <*> cliConfig.exportJsonSchemaPath
              <*> cliConfig.clientPort

        maybe (throwError $ error "invalid developmentConfigTarget") (pure <<< Development) developmentConfigTarget

  pure
    { target

    , port: cliConfig.port
    , hostname: cliConfig.hostname

    , rootUrl: cliConfig.rootUrl

    , databaseName:                  cliConfig.databaseName
    , databaseHost:                  cliConfig.databaseHost
    , databasePort:                  cliConfig.databasePort
    , databaseOwnerUser:             cliConfig.databaseOwnerUser
    , databaseOwnerPassword:         envConfig.databaseOwnerPassword
    , databaseAuthenticatorUser:     cliConfig.databaseAuthenticatorUser
    , databaseAuthenticatorPassword: envConfig.databaseAuthenticatorPassword
    , databaseVisitorUser:           cliConfig.databaseVisitorUser

    , oauthGithubClientID:     cliConfig.oauthGithubClientID
    , oauthGithubClientSecret: envConfig.oauthGithubClientSecret

    , sessionSecret: envConfig.sessionSecret
    }

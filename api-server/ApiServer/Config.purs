module ApiServer.Config where

import Data.Maybe
import Pathy
import Protolude

import ApiServer.CliConfig as ApiServer.CliConfig
import ApiServer.EnvConfig (EnvConfig)
import ApiServer.EnvConfig as ApiServer.EnvConfig
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

type DevelopmentConfigTarget =
  { exportGqlSchemaPath  :: AnyFile
  , exportJsonSchemaPath :: AnyFile
  }

data ConfigTarget
  = Production
  | Development DevelopmentConfigTarget

-- from args
type Config =
  { target        :: ConfigTarget
  , port          :: Int
  , host          :: String
  , databaseUrl   :: String
  , exposedSchema :: String
  , jwtSecret     :: NonEmptyString
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
            (developmentConfigTarget :: Maybe DevelopmentConfigTarget) =
              { exportGqlSchemaPath: _
              , exportJsonSchemaPath: _
              }
              <$> cliConfig.exportGqlSchemaPath
              <*> cliConfig.exportJsonSchemaPath

        maybe (throwError $ error "invalid developmentConfigTarget") (pure <<< Development) developmentConfigTarget

  pure
    { target
    , port:          cliConfig.port
    , host:          cliConfig.host
    , databaseUrl:   cliConfig.databaseUrl
    , exposedSchema: cliConfig.exposedSchema
    , jwtSecret:     envConfig.jwtSecret
    }


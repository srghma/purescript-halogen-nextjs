module ApiServer.Config.FromCli where

import Pathy (Path, Abs, File, AnyFile)
import Protolude
import PathyOptparse as PathyOptparse
import Data.Maybe as Maybe

import Options.Applicative

type CliConfig =
  { exportGqlSchemaPath  :: Maybe AnyFile
  , exportJsonSchemaPath :: Maybe AnyFile
  , clientPort :: Maybe Int

  , port    :: Int
  , hostname    :: String
  , rootUrl :: String

  , databaseName              :: String
  , databaseHost              :: String
  , databasePort              :: Maybe Int

  , isProduction        :: Boolean
  , oauthGithubClientID :: String
  }

configParser :: Parser CliConfig
configParser = ado
  exportGqlSchemaPath  <- Maybe.optional $ option PathyOptparse.anyFilePosixParser $ long "export-gql-schema-path" <> metavar "ANYFILE"
  exportJsonSchemaPath <- Maybe.optional $ option PathyOptparse.anyFilePosixParser $ long "export-json-schema-path" <> metavar "ANYFILE"

  port       <- option int $ long "port" <> showDefault <> value 3000 <> metavar "INT"
  clientPort <- Maybe.optional $ option int $ long "client-port" <> metavar "INT"
  hostname   <- option str $ long "hostname" <> showDefault <> value "localhost" <> metavar "HOST"
  rootUrl    <- option str $ long "rootUrl" <> showDefault <> value "http://localhost:3000" <> metavar "URL"

  databaseName              <- option str $ long "database-name" <> metavar "NAME"
  databaseHost              <- option str $ long "database-hostname" <> metavar "NAME"
  databasePort              <- Maybe.optional $ option int $ long "database-port" <> metavar "NAME"

  oauthGithubClientID <- option str $ long "oauth-github-client-id" <> metavar "CLIENTID"

  isProduction <- switch $ long "production"

  in
    { exportGqlSchemaPath
    , exportJsonSchemaPath
    , clientPort
    , port
    , hostname
    , rootUrl
    , databaseName
    , databaseHost
    , databasePort
    , isProduction
    , oauthGithubClientID
    }

opts :: ParserInfo CliConfig
opts =
  info (configParser <**> helper) $ fullDesc <> progDesc "starts server" <> header "server - starts server"

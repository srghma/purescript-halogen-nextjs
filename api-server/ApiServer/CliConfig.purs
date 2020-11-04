module ApiServer.CliConfig where

import Pathy (Path, Abs, File, AnyFile)
import Protolude
import PathyOptparse as PathyOptparse
import Data.Maybe as Maybe

import Options.Applicative

type CliConfig =
  { exportGqlSchemaPath  :: Maybe AnyFile
  , exportJsonSchemaPath :: Maybe AnyFile

  , port    :: Int
  , host    :: String
  , rootUrl :: String

  , databaseName              :: String
  , databaseHost              :: String
  , databasePort              :: Maybe Int
  , databaseOwnerUser         :: String
  , databaseAuthenticatorUser :: String

  , isProdunction        :: Boolean
  , oauthGithubClientId :: String
  }

configParser :: Parser CliConfig
configParser = ado
  exportGqlSchemaPath  <- Maybe.optional $ option PathyOptparse.anyFilePosixParser $ long "export-gql-schema-path" <> metavar "ANYFILE"
  exportJsonSchemaPath <- Maybe.optional $ option PathyOptparse.anyFilePosixParser $ long "export-json-schema-path" <> metavar "ANYFILE"

  port <- option int
    ( long "port"
        <> showDefault
        <> value 3000
        <> metavar "INT"
    )

  host <- option str
    ( long "host"
        <> showDefault
        <> value "localhost"
        <> metavar "HOST"
    )

  rootUrl <- option str
    ( long "rootUrl"
        <> showDefault
        <> value "http://localhost:3000"
        <> metavar "URL"
    )

  databaseName              <- option str $ long "database-name" <> metavar "NAME"
  databaseHost              <- option str $ long "database-host" <> metavar "NAME"
  databasePort              <- Maybe.optional $ option int $ long "database-port" <> metavar "NAME"
  databaseOwnerUser         <- option str $ long "database-owner-user" <> metavar "NAME"
  databaseAuthenticatorUser <- option str $ long "database-authenticator-user" <> metavar "NAME"

  oauthGithubClientId <- option str $ long "oauth-github-client-id" <> metavar "CLIENTID"

  isProdunction <- switch $ long "produnction"

  in
    { exportGqlSchemaPath
    , exportJsonSchemaPath
    , port
    , host
    , rootUrl
    , databaseName
    , databaseHost
    , databasePort
    , databaseOwnerUser
    , databaseAuthenticatorUser
    , isProdunction
    , oauthGithubClientId
    }

opts :: ParserInfo CliConfig
opts =
  info (configParser <**> helper)
    ( fullDesc
        <> progDesc "starts server"
        <> header "server - starts server"
    )

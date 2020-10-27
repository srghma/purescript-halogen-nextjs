module ApiServer.CliConfig where

import Pathy (Path, Abs, File, AnyFile)
import Protolude
import PathyOptparse as PathyOptparse
import Data.Maybe as Maybe

import Options.Applicative

type CliConfig =
  { exportGqlSchemaPath  :: Maybe AnyFile
  , exportJsonSchemaPath :: Maybe AnyFile
  , port                 :: Int
  , host                 :: String
  , databaseUrl          :: String
  , exposedSchema        :: String
  , isProdunction        :: Boolean
  }

configParser :: Parser CliConfig
configParser =
  { exportGqlSchemaPath:  _
  , exportJsonSchemaPath: _
  , port:                 _
  , host:                 _
  , databaseUrl:          _
  , exposedSchema:        _
  , isProdunction:        _
  }
    <$> Maybe.optional (option PathyOptparse.anyFilePosixParser (long "export-gql-schema-path" <> metavar "ANYFILE"))
    <*> Maybe.optional (option PathyOptparse.anyFilePosixParser (long "export-json-schema-path" <> metavar "ANYFILE"))
    <*> option int
        ( long "port"
            <> help "0 - means random port"
            <> showDefault
            <> value 0
            <> metavar "INT"
        )
    <*> option str
        ( long "host"
            <> showDefault
            <> value "localhost"
            <> metavar "HOST"
        )
    <*> option str (long "database-url" <> metavar "URL")
    <*> option str (long "exposed-schema" <> metavar "NAME")
    <*> switch (long "produnction")

opts :: ParserInfo CliConfig
opts =
  info (configParser <**> helper)
    ( fullDesc
        <> progDesc "starts server"
        <> header "server - starts server"
    )

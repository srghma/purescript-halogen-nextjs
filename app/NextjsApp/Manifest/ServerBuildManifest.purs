module NextjsApp.Manifest.ServerBuildManifest where

import Protolude

import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Decode.Parser (parseJson) as ArgonautCodecs
import Effect.Console (log)
import Nextjs.Utils as Nextjs.Utils
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.Server.Config as NextjsApp.Server.Config
import Node.Encoding as Node.Encoding
import Node.FS.Sync as Node.FS.Sync
import Node.Path as Node.Path
import Pathy
import PathyExtra

type BuildManifest =
  { pages :: NextjsApp.Route.RouteIdMapping NextjsApp.Manifest.PageManifest.PageManifest
  , main :: NextjsApp.Manifest.PageManifest.PageManifest
  }

decodeBuildManifest :: String -> Either JsonDecodeError BuildManifest
decodeBuildManifest content = ArgonautCodecs.parseJson content >>= ArgonautCodecs.decodeJson

getBuildManifest :: NextjsApp.Server.Config.Config -> Effect BuildManifest
getBuildManifest config = do
  let manifestAbsPath = config.rootPath </> file (SProxy :: SProxy "build-manifest") <.> "json"

  content <- Node.FS.Sync.readTextFile Node.Encoding.UTF8 (printPathPosixSandboxAny manifestAbsPath)

  case decodeBuildManifest content of
       Left decodeError -> do
          log $ "Error when decoding manifest:\n" <> content
          throwError $ error $ ArgonautCodecs.printJsonDecodeError decodeError
       Right manifest -> pure manifest

module Nextjs.Manifest.ServerBuildManifest where

import Protolude

import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Decode.Parser (parseJson) as ArgonautCodecs
import Effect.Console (log)
import Nextjs.Lib.Utils as Nextjs.Lib.Utils
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Route as Nextjs.Route
import Nextjs.Server.Config as Nextjs.Server.Config
import Node.Encoding as Node.Encoding
import Node.FS.Sync as Node.FS.Sync
import Node.Path as Node.Path

type BuildManifest =
  { pages :: Nextjs.Route.PagesRec Nextjs.Manifest.PageManifest.PageManifest
  , main :: Nextjs.Manifest.PageManifest.PageManifest
  }

decodeBuildManifest :: String -> Either JsonDecodeError BuildManifest
decodeBuildManifest content = ArgonautCodecs.parseJson content >>= ArgonautCodecs.decodeJson

getBuildManifest :: Nextjs.Server.Config.Config -> Effect BuildManifest
getBuildManifest config = do
  content <- Node.FS.Sync.readTextFile Node.Encoding.UTF8 (Node.Path.concat [config.rootPath, "build-manifest.json"])
  case decodeBuildManifest content of
       Left decodeError -> do
          log $ "Error when decoding manifest:\n" <> content
          throwError $ error $ ArgonautCodecs.printJsonDecodeError decodeError
       Right manifest -> pure manifest

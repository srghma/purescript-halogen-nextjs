module Nextjs.Manifest.ServerBuildManifest where

import Protolude (Effect, Either, bind, ($), (>>=))

import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode (decodeJson) as ArgonautCodecs
import Data.Argonaut.Decode.Parser (parseJson) as ArgonautCodecs
import Nextjs.Route as Nextjs.Route
import Nextjs.Server.Config as Nextjs.Server.Config
import Node.Encoding as Node.Encoding
import Node.FS.Sync as Node.FS.Sync
import Node.Path as Node.Path
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Lib.Utils as Nextjs.Lib.Utils

type BuildManifest =
  { pages :: Nextjs.Route.PagesRec Nextjs.Manifest.PageManifest.PageManifest
  , main :: Nextjs.Manifest.PageManifest.PageManifest
  }

decodeBuildManifest :: String -> Either JsonDecodeError BuildManifest
decodeBuildManifest content = ArgonautCodecs.parseJson content >>= ArgonautCodecs.decodeJson

getBuildManifest :: Nextjs.Server.Config.Config -> Effect BuildManifest
getBuildManifest config = do
  content <- Node.FS.Sync.readTextFile Node.Encoding.UTF8 (Node.Path.concat [config.rootPath, "build-manifest.json"])
  Nextjs.Lib.Utils.requiredJsonDecodeResult $ decodeBuildManifest content

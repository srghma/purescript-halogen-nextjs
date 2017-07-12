module Nextjs.Manifest.ServerBuildManifest where

import Data.Argonaut.Core
import Options.Applicative
import Protolude

import Ansi.Codes (Color(..)) as Ansi
import Ansi.Output (foreground, withGraphics) as Ansi
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError)
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Decode.Parser as ArgonautCodecs
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Argonaut.Parser as Data.Argonaut.Parser
import Data.Generic.Rep.Show (genericShow)
import Data.Int as Integers
import Data.Map (Map)
import Effect.Class.Console as Console
import Nextjs.Route as Nextjs.Route
import Nextjs.Server.Config as Nextjs.Server.Config
import Node.Encoding as Node.Encoding
import Node.FS.Sync as Node.FS.Sync
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

module Nextjs.Manifest.ClientPagesManifest where

import Protolude

import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Route as Nextjs.Route
import Nextjs.Lib.Utils as Nextjs.Lib.Utils
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Data.Argonaut.Decode as ArgonautCodecs
import Nextjs.Constants as Nextjs.Constants

type ClientPagesManifest = Nextjs.Route.PagesRec Nextjs.Manifest.PageManifest.PageManifest

getBuildManifest :: Aff ClientPagesManifest
getBuildManifest = do
  json <- Nextjs.Lib.Utils.findJsonFromScriptElement (Web.DOM.ParentNode.QuerySelector Nextjs.Constants.pagesManifestId)
  Nextjs.Lib.Utils.requiredJsonDecodeResult $ ArgonautCodecs.decodeJson json

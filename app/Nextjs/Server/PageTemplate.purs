module Nextjs.Server.PageTemplate where

import Protolude

import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Encode as ArgonautCodecs
import Data.MediaType.Common as MediaTypes
import Data.String (joinWith) as String
import Halogen.HTML as Halogen.HTML
import Halogen.HTML.Elements as Halogen.HTML.Elements
import Halogen.HTML.Properties as Halogen.HTML.Properties
import Nextjs.Lib.HalogenElements as Nextjs.Lib.HalogenElements
import Nextjs.Lib.RenderHtmlWithRawTextSupport as Nextjs.Lib.RenderHtmlWithRawTextSupport
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Data.Nullable (Nullable)
import Data.Nullable as Nullable

-- renderToStaticMarkup - https://github.com/zeit/next.js/blob/86236bc76bcfc69b4e704f06be5b29cda3c1908c/packages/next/next-server/server/render.tsx#L234
-- NextScript - https://github.com/zeit/next.js/blob/86236bc76bcfc69b4e704f06be5b29cda3c1908c/packages/next/pages/_document.tsx#L558

jsPreload :: String -> String
jsPreload path = "<link rel=\"preload\" as=\"script\" href=\"" <> path <> "\"/>"

css :: String -> String
css path = "<link rel=\"stylesheet\" href=\"" <> path <> "\"/>"

jsAsync :: String -> String
jsAsync path = "<script async=\"\" type=\"application/javascript\" src=\"" <> path <> "\"></script>"

data StaticOrDynamicPageData
  = StaticPageData -- no need to render __PAGE_DATA__
  | DynamicPageData ArgonautCore.Json

type PageSpecServerRendered =
  { pageData :: StaticOrDynamicPageData
  , component :: String
  , title :: String
  }

foreign import template
  :: { target :: String
     , headTags :: String
     , bodyTags :: String
     , title :: String
     , prerenderedHtml :: String
     , prerenderedPagesManifest :: String
     , prerenderedPageData :: Nullable String
     }
  -> String

pageTemplate :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest -> Nextjs.Manifest.PageManifest.PageManifest -> PageSpecServerRendered -> String
pageTemplate clientPagesManifest currentPageManifest pageSpecResolved = template
  { target: "server"
  , headTags: String.joinWith "\n" $ (currentPageManifest.js <#> jsPreload) <> (currentPageManifest.css <#> css)
  , bodyTags: String.joinWith "\n" $ currentPageManifest.js <#> jsAsync
  , title: pageSpecResolved.title
  , prerenderedHtml: pageSpecResolved.component
  , prerenderedPagesManifest: ArgonautCore.stringify (ArgonautCodecs.encodeJson clientPagesManifest)
  , prerenderedPageData:
    case pageSpecResolved.pageData of
         StaticPageData -> Nullable.null
         DynamicPageData json -> Nullable.notNull $ ArgonautCore.stringify json
  }

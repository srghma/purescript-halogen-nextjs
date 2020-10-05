module NextjsApp.Server.PageTemplate where

import Protolude

import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Encode as ArgonautCodecs
import Data.String as String
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import NextjsApp.Template as Template

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

pageTemplate :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest -> NextjsApp.Manifest.PageManifest.PageManifest -> PageSpecServerRendered -> String
pageTemplate clientPagesManifest currentPageManifest pageSpecResolved = Template.template
  { targetData: Template.TargetData__Server
    { prerenderedHtml: pageSpecResolved.component
    , prerenderedPagesManifest: ArgonautCore.stringify (ArgonautCodecs.encodeJson clientPagesManifest)
    , prerenderedPageData:
      case pageSpecResolved.pageData of
           StaticPageData -> Nothing
           DynamicPageData json -> Just $ ArgonautCore.stringify json
    }
  , headTags: (currentPageManifest.js <#> jsPreload) <> (currentPageManifest.css <#> css)
  , bodyTags: currentPageManifest.js <#> jsAsync
  , title: pageSpecResolved.title
  }

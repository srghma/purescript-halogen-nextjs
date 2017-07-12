module Nextjs.Server.PageTemplate where

import Protolude

import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Encode as ArgonautCodecs
import Data.MediaType.Common as MediaTypes
import Halogen.HTML as Halogen.HTML
import Halogen.HTML.Elements as Halogen.HTML.Elements
import Halogen.HTML.Properties as Halogen.HTML.Properties
import Nextjs.Lib.HalogenElements as Nextjs.Lib.HalogenElements
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Lib.RenderHtmlWithRawTextSupport as Nextjs.Lib.RenderHtmlWithRawTextSupport
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest

-- renderToStaticMarkup - https://github.com/zeit/next.js/blob/86236bc76bcfc69b4e704f06be5b29cda3c1908c/packages/next/next-server/server/render.tsx#L234
-- NextScript - https://github.com/zeit/next.js/blob/86236bc76bcfc69b4e704f06be5b29cda3c1908c/packages/next/pages/_document.tsx#L558

jsPreload :: forall w i. String -> Halogen.HTML.HTML w i
jsPreload path =
  Halogen.HTML.Elements.link
    [ Halogen.HTML.Properties.rel "preload"
    , Nextjs.Lib.HalogenElements.as_ "script"
    , Halogen.HTML.Properties.href path
    ]

css :: forall w i. String -> Halogen.HTML.HTML w i
css path =
  Halogen.HTML.Elements.link
    [ Halogen.HTML.Properties.rel "stylesheet"
    , Halogen.HTML.Properties.href path
    ]

jsAsync :: forall w i. String -> Halogen.HTML.HTML w i
jsAsync path =
  Halogen.HTML.Elements.script
    [ Nextjs.Lib.HalogenElements.async ""
    , Halogen.HTML.Properties.type_ MediaTypes.applicationJavascript
    , Halogen.HTML.Properties.src path
    ]
    []

cssInline :: forall w i. String -> Halogen.HTML.HTML w i
cssInline content =
  Halogen.HTML.Elements.style
    [ Halogen.HTML.Properties.type_ MediaTypes.textCSS
    , Nextjs.Lib.HalogenElements.media_ "screen"
    ]
    [ Halogen.HTML.text content
    ]

data StaticOrDynamicPageData
  = StaticPageData -- no need to render __PAGE_DATA__
  | DynamicPageData ArgonautCore.Json

type PageSpecServerRendered =
  { pageData :: StaticOrDynamicPageData
  , component :: String
  , title :: String
  }

pageTemplate :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest -> Nextjs.Manifest.PageManifest.PageManifest -> PageSpecServerRendered -> String
pageTemplate clientPagesManifest currentPageManifest pageSpecResolved = "<!DOCTYPE html>" <> (traceId htmlRendered)
  where
    htmlRendered :: String
    htmlRendered = Nextjs.Lib.RenderHtmlWithRawTextSupport.renderHtmlWithRawTextSupport html

    html :: ∀ i . Halogen.HTML.HTML (Nextjs.Lib.RenderHtmlWithRawTextSupport.RawTextWidget) i
    html =
      Halogen.HTML.Elements.html_
        [ Halogen.HTML.Elements.head_
          ( [ Halogen.HTML.Elements.meta
              [ Halogen.HTML.Properties.charset "utf-8"
              ]
            , Halogen.HTML.Elements.meta
              [ Halogen.HTML.Properties.name "viewport"
              , Nextjs.Lib.HalogenElements.content "width=device-width,initial-scale=1"
              ]
            , Halogen.HTML.Elements.title_
              [ Halogen.HTML.text pageSpecResolved.title
              ]
            ]
            <> (currentPageManifest.js <#> jsPreload)
            <> (currentPageManifest.css <#> css)
          )
        , Halogen.HTML.Elements.body_
          ( [ Halogen.HTML.Elements.div
              [ Halogen.HTML.Properties.id_ "root"
              ]
              [ Nextjs.Lib.RenderHtmlWithRawTextSupport.rawText pageSpecResolved.component
              ]
            , Halogen.HTML.Elements.script
              [ Halogen.HTML.Properties.id_ "__PAGES_MANIFEST__"
              , Halogen.HTML.Properties.type_ MediaTypes.applicationJSON
              ]
              [ Nextjs.Lib.RenderHtmlWithRawTextSupport.rawText $ ArgonautCore.stringify (ArgonautCodecs.encodeJson clientPagesManifest)
              ]
            ] <> (
              case pageSpecResolved.pageData of
                   StaticPageData -> []
                   DynamicPageData json ->
                      [ Halogen.HTML.Elements.script
                          [ Halogen.HTML.Properties.id_ "__PAGE_DATA__"
                          , Halogen.HTML.Properties.type_ MediaTypes.applicationJSON
                          ]
                          [ Nextjs.Lib.RenderHtmlWithRawTextSupport.rawText $ ArgonautCore.stringify json
                          ]
                      ]
            ) <> (currentPageManifest.js <#> jsAsync)
          )
        ]

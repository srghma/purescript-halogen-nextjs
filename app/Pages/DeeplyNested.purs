module Nextjs.Pages.DeeplyNested (page) where

import Protolude
import Example.DeeplyNested.A as Example.DeeplyNested.A
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.DeeplyNested.A.component
  , title: "Halogen Example - DeeplyNested button"
  }

page :: Page
page = mkPage pageSpec

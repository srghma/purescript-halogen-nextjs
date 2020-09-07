module Nextjs.Pages.Examples.DeeplyNested (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.DeeplyNested.A as Example.DeeplyNested.A
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.DeeplyNested.A.component
  , title: "Halogen Example - DeeplyNested button"
  }

page :: Page
page = mkPage pageSpec

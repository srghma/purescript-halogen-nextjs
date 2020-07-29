module Nextjs.Pages.Buttons.Fabs (page) where

import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Protolude (Unit, liftAff, unit, ($))
import Halogen as H
import Nextjs.PageImplementations.Buttons.Fabs as Implementation

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Implementation.component
  , title: "Halogen MWC - Buttons Fabs"
  }

page :: Page
page = mkPage pageSpec

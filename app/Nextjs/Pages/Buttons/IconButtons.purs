module Nextjs.Pages.Buttons.IconButtons (page) where

import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Protolude (Unit, liftAff, unit, ($))
import Halogen as H
import Nextjs.PageImplementations.Buttons.IconButtons as Implementation

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Implementation.component
  , title: "Halogen MWC - Buttons IconButtons"
  }

page :: Page
page = mkPage pageSpec

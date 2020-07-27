module Nextjs.Pages.TextNodes (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.TextNodes.Main as Example.TextNodes.Main
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.TextNodes.Main.component
  , title: "Halogen Example - Text nodes"
  }

page :: Page
page = mkPage pageSpec

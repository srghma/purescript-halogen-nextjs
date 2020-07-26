module Nextjs.Pages.Lazy (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Lazy.Main as Example.Lazy.Main
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Lazy.Main.component
  , title: "Halogen Example - lazy"
  }

page :: Page
page = mkPage pageSpec

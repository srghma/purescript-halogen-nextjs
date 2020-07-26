module Nextjs.Pages.ComponentsMultitype (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Components.Multitype.Container as Container
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - components multitype button"
  }

page :: Page
page = mkPage pageSpec

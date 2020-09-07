module Nextjs.Pages.Examples.Components (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Components.Container as Example.Components.Container
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Components.Container.component
  , title: "Halogen Example - Components button"
  }

page :: Page
page = mkPage pageSpec

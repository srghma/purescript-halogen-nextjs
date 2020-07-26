module Nextjs.Pages.ComponentsInputs (page) where

import Protolude (Unit, liftAff, unit, ($))
import Example.Components.Inputs.Container as Container
import Nextjs.Lib.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - Components with inputs example"
  }

page :: Page
page = mkPage pageSpec

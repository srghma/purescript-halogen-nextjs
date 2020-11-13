module NextjsApp.Pages.Examples.ComponentsInputs (page) where

import Protolude
import Example.Components.Inputs.Container as Container
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - Components with inputs example"
  }

page :: Page
page = mkPage pageSpec

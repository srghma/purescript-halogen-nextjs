module NextjsApp.Pages.Examples.Components (page) where

import Protolude
import Example.Components.Container as Example.Components.Container
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Components.Container.component
  , title: "Halogen Example - Components button"
  }

page :: Page
page = mkPage pageSpec

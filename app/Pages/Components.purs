module Nextjs.Pages.Components (page) where

import Protolude
import Example.Components.Container as Example.Components.Container
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Components.Container.component
  , title: "Halogen Example - Components button"
  }

page :: Page
page = mkPage pageSpec

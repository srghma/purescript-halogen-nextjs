module Nextjs.Pages.ComponentsInputs (page) where

import Protolude
import Example.Components.Inputs.Container as Container
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - Components with inputs example"
  }

page :: Page
page = mkPage pageSpec

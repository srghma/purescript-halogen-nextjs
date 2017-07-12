module Nextjs.Pages.ComponentsMultitype (page) where

import Protolude
import Example.Components.Multitype.Container as Container
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - components multitype button"
  }

page :: Page
page = mkPage pageSpec

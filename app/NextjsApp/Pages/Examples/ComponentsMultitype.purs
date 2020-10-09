module NextjsApp.Pages.Examples.ComponentsMultitype (page) where

import Protolude
import Example.Components.Multitype.Container as Container
import Nextjs.Page (Page, PageData(..), PageSpec, mkPage)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Container.component
  , title: "Halogen Example - components multitype button"
  }

page :: Page
page = mkPage pageSpec

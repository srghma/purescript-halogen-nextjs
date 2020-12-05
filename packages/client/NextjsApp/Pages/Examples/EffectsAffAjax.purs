module NextjsApp.Pages.Examples.EffectsAffAjax (page) where

import Protolude
import Example.Effects.Aff.Ajax.Component as Example.Effects.Aff.Ajax.Component
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Effects.Aff.Ajax.Component.component
  , title: "Halogen Example - EffectsAffAjax button"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

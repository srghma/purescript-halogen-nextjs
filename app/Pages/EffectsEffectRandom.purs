module Nextjs.Pages.EffectsEffectRandom (page) where

import Protolude
import Example.Effects.Effect.Random.Component as Example.Effects.Effect.Random.Component
import Halogen.HTML as Halogen.HTML
import Nextjs.Lib.Page
import Halogen as H

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: StaticPageData unit
  , component: H.hoist liftAff $ Example.Effects.Effect.Random.Component.component
  , title: "Halogen Example - EffectsEffectRandom button"
  }

page :: Page
page = mkPage pageSpec

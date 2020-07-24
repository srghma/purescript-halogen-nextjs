module Lib.Pages.Index.Default (component) where

import Protolude

import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Lib.Link as Lib.Link
import Nextjs.Route (Route(..))
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Nextjs.AppM

allRoutes :: Array Route
allRoutes =
  [ Ace
  , Basic
  , Components
  , ComponentsInputs
  , ComponentsMultitype
  , EffectsAffAjax
  , EffectsEffectRandom
  , HigherOrderComponents
  , Interpret
  , KeyboardInput
  , Lifecycle
  , DynamicInput
  , DeeplyNested
  , TextNodes
  , Lazy
  ]

component :: forall q i o . H.Component q i o AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render state =
  HH.ul_ $
    allRoutes <#> (\route ->
      HH.li_ $
        let route' = show route
        in
          [ HH.slot (SProxy :: _ "mylink") route Lib.Link.component { route, text: route' } absurd
          ]
      )

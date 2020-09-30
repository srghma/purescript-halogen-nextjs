module NextjsApp.PageImplementations.Index (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import NextjsApp.Link as NextjsApp.Link
import NextjsApp.Route (Examples(..), Route(..))

allRoutes :: Array Route
allRoutes =
  [ Index
  , Login
  , Signup
  , Secret
  ] <>
  ( map Examples $
    [ Examples__Ace
    , Examples__Basic
    , Examples__Components
    , Examples__ComponentsInputs
    , Examples__ComponentsMultitype
    , Examples__EffectsAffAjax
    , Examples__EffectsEffectRandom
    , Examples__HigherOrderComponents
    , Examples__Interpret
    , Examples__KeyboardInput
    , Examples__Lifecycle
    , Examples__DeeplyNested
    , Examples__DynamicInput
    , Examples__TextNodes
    , Examples__Lazy
    ]
  )

component :: forall query input output . H.Component query input output AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render
  :: forall action state
   . state
  -> HH.ComponentHTML action ( mylink :: Slot NextjsApp.Link.Query NextjsApp.Link.Message Route ) AppM
render _ =
  HH.ul_ $
    allRoutes <#> \route ->
      HH.li_ $
        [ HH.slot
          (SProxy :: SProxy "mylink")
          route
          NextjsApp.Link.component
          { route, text: show route }
          absurd
        ]

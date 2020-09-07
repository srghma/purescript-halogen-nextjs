module Nextjs.PageImplementations.Index (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import Nextjs.AppM (AppM)
import Nextjs.Link.Default as Nextjs.Link.Default
import Nextjs.Route (Examples(..), Route(..))

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
  -> HH.ComponentHTML action ( mylink :: Slot Nextjs.Link.Default.Query Nextjs.Link.Default.Message Route ) AppM
render _ =
  HH.ul_ $
    allRoutes <#> \route ->
      HH.li_ $
        [ HH.slot
          (SProxy :: SProxy "mylink")
          route
          Nextjs.Link.Default.component
          { route, text: show route }
          absurd
        ]

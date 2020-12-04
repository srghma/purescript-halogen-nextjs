module NextjsApp.PageImplementations.Index (component) where

import Protolude
import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import NextjsApp.Link as NextjsApp.Link
import NextjsApp.Route (Route(..), RouteExamples(..))

allRoutes :: Array Route
allRoutes =
  [ Index
  , Login
  , Register
  , Secret
  ]
  <>
  ( RouteExamples <$>
    [ RouteExamples__Ace
    , RouteExamples__Basic
    , RouteExamples__Components
    , RouteExamples__ComponentsInputs
    , RouteExamples__ComponentsMultitype
    , RouteExamples__EffectsAffAjax
    , RouteExamples__EffectsEffectRandom
    , RouteExamples__HigherOrderComponents
    , RouteExamples__Interpret
    , RouteExamples__KeyboardInput
    , RouteExamples__Lifecycle
    , RouteExamples__DeeplyNested
    , RouteExamples__TextNodes
    , RouteExamples__Lazy
    ]
  )

component :: forall query input output. H.Component query input output AppM
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render ::
  forall action state.
  state ->
  HH.ComponentHTML action ( mylink :: Slot NextjsApp.Link.Query NextjsApp.Link.Message Route ) AppM
render _ =
  HH.div_
    [ HH.text "test"
    , HH.ul_
        $ allRoutes
        <#> \route ->
            HH.li_
              $ [ HH.slot
                    (SProxy :: SProxy "mylink")
                    route
                    NextjsApp.Link.component
                    { route, text: show route }
                    absurd
                ]
    ]

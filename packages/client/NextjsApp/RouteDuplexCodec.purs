module NextjsApp.RouteDuplexCodec where

import NextjsApp.Route (Route, RouteExamples)
import Protolude
import Routing.Duplex as Routing.Duplex
import Routing.Duplex.Generic as Routing.Duplex
import Routing.Duplex.Generic.Syntax ((/))

routeCodec :: Routing.Duplex.RouteDuplex' Route
routeCodec =
  Routing.Duplex.root
    $ Routing.Duplex.sum
        { "Index": Routing.Duplex.noArgs
        , "Login": "login" / Routing.Duplex.noArgs
        , "Signup": "signup" / Routing.Duplex.noArgs
        , "Secret": "secret" / Routing.Duplex.noArgs
        , "RouteExamples": "examples" / routesexamplesCodec
        }
  where
  routesexamplesCodec :: Routing.Duplex.RouteDuplex' RouteExamples
  routesexamplesCodec =
    Routing.Duplex.sum
      { "RouteExamples__Ace": "ace" / Routing.Duplex.noArgs
      , "RouteExamples__Basic": "basic" / Routing.Duplex.noArgs
      , "RouteExamples__Components": "components" / Routing.Duplex.noArgs
      , "RouteExamples__ComponentsInputs": "components-inputs" / Routing.Duplex.noArgs
      , "RouteExamples__ComponentsMultitype": "components-multitype" / Routing.Duplex.noArgs
      , "RouteExamples__EffectsAffAjax": "effects-aff-ajax" / Routing.Duplex.noArgs
      , "RouteExamples__EffectsEffectRandom": "effects-effect-random" / Routing.Duplex.noArgs
      , "RouteExamples__HigherOrderComponents": "higher-order-components" / Routing.Duplex.noArgs
      , "RouteExamples__Interpret": "interpret" / Routing.Duplex.noArgs
      , "RouteExamples__KeyboardInput": "keyboard-input" / Routing.Duplex.noArgs
      , "RouteExamples__Lifecycle": "lifecycle" / Routing.Duplex.noArgs
      , "RouteExamples__DeeplyNested": "deeply-nested" / Routing.Duplex.noArgs
      , "RouteExamples__DynamicInput": "dynamic-input" / Routing.Duplex.noArgs
      , "RouteExamples__TextNodes": "text-nodes" / Routing.Duplex.noArgs
      , "RouteExamples__Lazy": "lazy" / Routing.Duplex.noArgs
      }

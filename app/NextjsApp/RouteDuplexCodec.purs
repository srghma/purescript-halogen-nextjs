module NextjsApp.RouteDuplexCodec where

import NextjsApp.Route
import Effect.Exception.Unsafe
import Protolude hiding ((/))

import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Generic.Rep.Show (genericShow)
import Data.Lens as Lens
import Data.Lens.Iso as Lens
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Regex
import Data.String.Regex.Unsafe as Regex
import Routing.Duplex (RouteDuplex', root) as Routing.Duplex
import Routing.Duplex.Generic (noArgs, sum) as Routing.Duplex
import Routing.Duplex.Generic.Syntax ((/))
import Unsafe.Coerce (unsafeCoerce)
import Foreign.Object as Object

routeCodec :: Routing.Duplex.RouteDuplex' Route
routeCodec = Routing.Duplex.root $ Routing.Duplex.sum
  { "Index":    Routing.Duplex.noArgs
  , "Login":    "login" / Routing.Duplex.noArgs
  , "Signup":   "signup" / Routing.Duplex.noArgs
  , "Secret":   "secret" / Routing.Duplex.noArgs
  , "RouteExamples": "routesexamples" / routesexamplesCodec
  }
  where
    routesexamplesCodec :: Routing.Duplex.RouteDuplex' RouteExamples
    routesexamplesCodec = Routing.Duplex.sum
      { "RouteExamples__Ace":                   "ace" / Routing.Duplex.noArgs
      , "RouteExamples__Basic":                 "basic" / Routing.Duplex.noArgs
      , "RouteExamples__Components":            "components" / Routing.Duplex.noArgs
      , "RouteExamples__ComponentsInputs":      "components-inputs" / Routing.Duplex.noArgs
      , "RouteExamples__ComponentsMultitype":   "components-multitype" / Routing.Duplex.noArgs
      , "RouteExamples__EffectsAffAjax":        "effects-aff-ajax" / Routing.Duplex.noArgs
      , "RouteExamples__EffectsEffectRandom":   "effects-effect-random" / Routing.Duplex.noArgs
      , "RouteExamples__HigherOrderComponents": "higher-order-components" / Routing.Duplex.noArgs
      , "RouteExamples__Interpret":             "interpret" / Routing.Duplex.noArgs
      , "RouteExamples__KeyboardInput":         "keyboard-input" / Routing.Duplex.noArgs
      , "RouteExamples__Lifecycle":             "lifecycle" / Routing.Duplex.noArgs
      , "RouteExamples__DeeplyNested":          "deeply-nested" / Routing.Duplex.noArgs
      , "RouteExamples__DynamicInput":          "dynamic-input" / Routing.Duplex.noArgs
      , "RouteExamples__TextNodes":             "text-nodes" / Routing.Duplex.noArgs
      , "RouteExamples__Lazy":                  "lazy" / Routing.Duplex.noArgs
      }


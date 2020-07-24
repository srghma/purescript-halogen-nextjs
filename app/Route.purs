module Nextjs.Route where

import Protolude hiding ((/))

import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Generic.Rep.Show (genericShow)
import Routing.Duplex as Routing.Duplex
import Routing.Duplex.Generic as Routing.Duplex
import Routing.Duplex.Generic.Syntax ((/))

data Route
  = Index
  | Ace
  | Basic
  | Components
  | ComponentsInputs
  | ComponentsMultitype
  | EffectsAffAjax
  | EffectsEffectRandom
  | HigherOrderComponents
  | Interpret
  | KeyboardInput
  | Lifecycle
  | DeeplyNested
  | DynamicInput
  | TextNodes
  | Lazy

derive instance genericRoute :: Generic Route _
derive instance eqRoute :: Eq Route
derive instance ordRoute :: Ord Route
instance showRoute :: Show Route where show = genericShow

instance encodeJsonRoute :: EncodeJson Route where
  encodeJson = genericEncodeJson

instance decodeJsonRoute :: DecodeJson Route where
  decodeJson = genericDecodeJson

routeCodec :: Routing.Duplex.RouteDuplex' Route
routeCodec = Routing.Duplex.root $ Routing.Duplex.sum
  { "Index":                 Routing.Duplex.noArgs
  , "Ace":                   "Ace" / Routing.Duplex.noArgs
  , "Basic":                 "Basic" / Routing.Duplex.noArgs
  , "Components":            "Components" / Routing.Duplex.noArgs
  , "ComponentsInputs":      "ComponentsInputs" / Routing.Duplex.noArgs
  , "ComponentsMultitype":   "ComponentsMultitype" / Routing.Duplex.noArgs
  , "EffectsAffAjax":        "EffectsAffAjax" / Routing.Duplex.noArgs
  , "EffectsEffectRandom":   "EffectsEffectRandom" / Routing.Duplex.noArgs
  , "HigherOrderComponents": "HigherOrderComponents" / Routing.Duplex.noArgs
  , "Interpret":             "Interpret" / Routing.Duplex.noArgs
  , "KeyboardInput":         "KeyboardInput" / Routing.Duplex.noArgs
  , "Lifecycle":             "Lifecycle" / Routing.Duplex.noArgs
  , "DynamicInput":          "DynamicInput" / Routing.Duplex.noArgs
  , "DeeplyNested":          "DeeplyNested" / Routing.Duplex.noArgs
  , "TextNodes":             "TextNodes" / Routing.Duplex.noArgs
  , "Lazy":                  "Lazy" / Routing.Duplex.noArgs
  }

type PagesRec a =
  { "Index" :: a
  , "Ace" :: a
  , "Basic" :: a
  , "Components" :: a
  , "ComponentsInputs" :: a
  , "ComponentsMultitype" :: a
  , "EffectsAffAjax" :: a
  , "EffectsEffectRandom" :: a
  , "HigherOrderComponents" :: a
  , "Interpret" :: a
  , "KeyboardInput" :: a
  , "Lifecycle" :: a
  , "DynamicInput" :: a
  , "DeeplyNested" :: a
  , "TextNodes" :: a
  , "Lazy" :: a
  }

extractFromPagesRec :: forall a . Route -> PagesRec a -> a
extractFromPagesRec Index                 = _."Index"
extractFromPagesRec Ace                   = _."Ace"
extractFromPagesRec Basic                 = _."Basic"
extractFromPagesRec Components            = _."Components"
extractFromPagesRec ComponentsInputs      = _."ComponentsInputs"
extractFromPagesRec ComponentsMultitype   = _."ComponentsMultitype"
extractFromPagesRec EffectsAffAjax        = _."EffectsAffAjax"
extractFromPagesRec EffectsEffectRandom   = _."EffectsEffectRandom"
extractFromPagesRec HigherOrderComponents = _."HigherOrderComponents"
extractFromPagesRec Interpret             = _."Interpret"
extractFromPagesRec KeyboardInput         = _."KeyboardInput"
extractFromPagesRec Lifecycle             = _."Lifecycle"
extractFromPagesRec DynamicInput          = _."DynamicInput"
extractFromPagesRec DeeplyNested          = _."DeeplyNested"
extractFromPagesRec TextNodes             = _."TextNodes"
extractFromPagesRec Lazy                  = _."Lazy"

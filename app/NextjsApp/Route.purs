module NextjsApp.Route where

import Protolude hiding ((/))

import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Generic.Rep.Show (genericShow)
import Routing.Duplex (RouteDuplex', root) as Routing.Duplex
import Routing.Duplex.Generic (noArgs, sum) as Routing.Duplex
import Routing.Duplex.Generic.Syntax ((/))

data Examples
  = Examples__Ace
  | Examples__Basic
  | Examples__Components
  | Examples__ComponentsInputs
  | Examples__ComponentsMultitype
  | Examples__EffectsAffAjax
  | Examples__EffectsEffectRandom
  | Examples__HigherOrderComponents
  | Examples__Interpret
  | Examples__KeyboardInput
  | Examples__Lifecycle
  | Examples__DeeplyNested
  | Examples__DynamicInput
  | Examples__TextNodes
  | Examples__Lazy

derive instance genericExamples :: Generic Examples _
derive instance eqExamples :: Eq Examples
derive instance ordExamples :: Ord Examples
instance showExamples :: Show Examples where show = genericShow
instance encodeJsonExamples :: EncodeJson Examples where encodeJson = genericEncodeJson
instance decodeJsonExamples :: DecodeJson Examples where decodeJson = genericDecodeJson

data Route
  = Index
  | Login
  | Signup
  | Secret
  | Examples Examples

derive instance genericRoute :: Generic Route _
derive instance eqRoute :: Eq Route
derive instance ordRoute :: Ord Route
instance showRoute :: Show Route where show = genericShow
instance encodeJsonRoute :: EncodeJson Route where encodeJson = genericEncodeJson
instance decodeJsonRoute :: DecodeJson Route where decodeJson = genericDecodeJson

routeCodec :: Routing.Duplex.RouteDuplex' Route
routeCodec = Routing.Duplex.root $ Routing.Duplex.sum
  { "Index":    Routing.Duplex.noArgs
  , "Login":    "login" / Routing.Duplex.noArgs
  , "Signup":   "signup" / Routing.Duplex.noArgs
  , "Secret":   "secret" / Routing.Duplex.noArgs
  , "Examples": "examples" / examplesCodec
  }
  where
    examplesCodec :: Routing.Duplex.RouteDuplex' Examples
    examplesCodec = Routing.Duplex.sum
      { "Examples__Ace":                   "ace" / Routing.Duplex.noArgs
      , "Examples__Basic":                 "basic" / Routing.Duplex.noArgs
      , "Examples__Components":            "components" / Routing.Duplex.noArgs
      , "Examples__ComponentsInputs":      "components-inputs" / Routing.Duplex.noArgs
      , "Examples__ComponentsMultitype":   "components-multitype" / Routing.Duplex.noArgs
      , "Examples__EffectsAffAjax":        "effects-aff-ajax" / Routing.Duplex.noArgs
      , "Examples__EffectsEffectRandom":   "effects-effect-random" / Routing.Duplex.noArgs
      , "Examples__HigherOrderComponents": "higher-order-components" / Routing.Duplex.noArgs
      , "Examples__Interpret":             "interpret" / Routing.Duplex.noArgs
      , "Examples__KeyboardInput":         "keyboard-input" / Routing.Duplex.noArgs
      , "Examples__Lifecycle":             "lifecycle" / Routing.Duplex.noArgs
      , "Examples__DeeplyNested":          "deeply-nested" / Routing.Duplex.noArgs
      , "Examples__DynamicInput":          "dynamic-input" / Routing.Duplex.noArgs
      , "Examples__TextNodes":             "text-nodes" / Routing.Duplex.noArgs
      , "Examples__Lazy":                  "lazy" / Routing.Duplex.noArgs
      }

-- where the key is an id of the page in the page manifest
-- pagesManifestRec
-- XXX: SHOULD NOT BE MULTILEVEL/NESTED!!!!
pagesRecSeparator :: String
pagesRecSeparator = "."

type PagesRecRow a =
  ( "Index"  :: a
  , "Login"  :: a
  , "Signup" :: a
  , "Secret" :: a

  -- is using pagesRecSeparator
  , "Examples.Ace"                   :: a
  , "Examples.Basic"                 :: a
  , "Examples.Components"            :: a
  , "Examples.ComponentsInputs"      :: a
  , "Examples.ComponentsMultitype"   :: a
  , "Examples.EffectsAffAjax"        :: a
  , "Examples.EffectsEffectRandom"   :: a
  , "Examples.HigherOrderComponents" :: a
  , "Examples.Interpret"             :: a
  , "Examples.KeyboardInput"         :: a
  , "Examples.Lifecycle"             :: a
  , "Examples.DeeplyNested"          :: a
  , "Examples.DynamicInput"          :: a
  , "Examples.TextNodes"             :: a
  , "Examples.Lazy"                  :: a
  )

type PagesRec a = Record (PagesRecRow a)

extractFromPagesRec :: forall a . Route -> PagesRec a -> a
extractFromPagesRec =
  case _ of
       Index  -> _."Index"
       Login  -> _."Login"
       Signup -> _."Signup"
       Secret -> _."Secret"
       Examples examples ->
         case examples of
              Examples__Ace                   -> _."Examples.Ace"
              Examples__Basic                 -> _."Examples.Basic"
              Examples__Components            -> _."Examples.Components"
              Examples__ComponentsInputs      -> _."Examples.ComponentsInputs"
              Examples__ComponentsMultitype   -> _."Examples.ComponentsMultitype"
              Examples__EffectsAffAjax        -> _."Examples.EffectsAffAjax"
              Examples__EffectsEffectRandom   -> _."Examples.EffectsEffectRandom"
              Examples__HigherOrderComponents -> _."Examples.HigherOrderComponents"
              Examples__Interpret             -> _."Examples.Interpret"
              Examples__KeyboardInput         -> _."Examples.KeyboardInput"
              Examples__Lifecycle             -> _."Examples.Lifecycle"
              Examples__DeeplyNested          -> _."Examples.DeeplyNested"
              Examples__DynamicInput          -> _."Examples.DynamicInput"
              Examples__TextNodes             -> _."Examples.TextNodes"
              Examples__Lazy                  -> _."Examples.Lazy"

routeToPageManifestId :: Route -> String
routeToPageManifestId =
  case _ of
       Index  -> "Index"
       Login  -> "Login"
       Signup -> "Signup"
       Secret -> "Secret"
       Examples examples ->
         case examples of
              Examples__Ace                   -> "Examples.Ace"
              Examples__Basic                 -> "Examples.Basic"
              Examples__Components            -> "Examples.Components"
              Examples__ComponentsInputs      -> "Examples.ComponentsInputs"
              Examples__ComponentsMultitype   -> "Examples.ComponentsMultitype"
              Examples__EffectsAffAjax        -> "Examples.EffectsAffAjax"
              Examples__EffectsEffectRandom   -> "Examples.EffectsEffectRandom"
              Examples__HigherOrderComponents -> "Examples.HigherOrderComponents"
              Examples__Interpret             -> "Examples.Interpret"
              Examples__KeyboardInput         -> "Examples.KeyboardInput"
              Examples__Lifecycle             -> "Examples.Lifecycle"
              Examples__DeeplyNested          -> "Examples.DeeplyNested"
              Examples__DynamicInput          -> "Examples.DynamicInput"
              Examples__TextNodes             -> "Examples.TextNodes"
              Examples__Lazy                  -> "Examples.Lazy"
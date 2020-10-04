module NextjsApp.Route where

import Data.Lens.Iso as Lens
import Data.Lens as Lens
import Effect.Exception.Unsafe
import Protolude hiding ((/))

import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Generic.Rep.Show (genericShow)
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Routing.Duplex (RouteDuplex', root) as Routing.Duplex
import Routing.Duplex.Generic (noArgs, sum) as Routing.Duplex
import Routing.Duplex.Generic.Syntax ((/))
import Unsafe.Coerce (unsafeCoerce)
import Data.String as String
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Regex
import Data.String.Regex.Unsafe as Regex

data RouteExamples
  = RouteExamples__Ace
  | RouteExamples__Basic
  | RouteExamples__Components
  | RouteExamples__ComponentsInputs
  | RouteExamples__ComponentsMultitype
  | RouteExamples__EffectsAffAjax
  | RouteExamples__EffectsEffectRandom
  | RouteExamples__HigherOrderComponents
  | RouteExamples__Interpret
  | RouteExamples__KeyboardInput
  | RouteExamples__Lifecycle
  | RouteExamples__DeeplyNested
  | RouteExamples__DynamicInput
  | RouteExamples__TextNodes
  | RouteExamples__Lazy

derive instance genericRoutesExamples :: Generic RouteExamples _
derive instance eqRoutesExamples :: Eq RouteExamples
derive instance ordRoutesExamples :: Ord RouteExamples
instance showRoutesExamples :: Show RouteExamples where show = genericShow
instance encodeJsonRoutesExamples :: EncodeJson RouteExamples where encodeJson = genericEncodeJson
instance decodeJsonRoutesExamples :: DecodeJson RouteExamples where decodeJson = genericDecodeJson

data Route
  = Index
  | Login
  | Signup
  | Secret
  | RouteExamples RouteExamples

derive instance genericRoute :: Generic Route _
derive instance eqRoute :: Eq Route
derive instance ordRoute :: Ord Route
instance showRoute :: Show Route where show = genericShow
instance encodeJsonRoute :: EncodeJson Route where encodeJson = genericEncodeJson
instance decodeJsonRoute :: DecodeJson Route where decodeJson = genericDecodeJson

routeIdSeparator :: NonEmptyString
routeIdSeparator = unsafeCoerce "__"

newtype RouteId = RouteId NonEmptyString -- e.g. "RouteExamples__Ace"

newtype RouteIdArray = RouteIdArray (NonEmptyArray NonEmptyString) -- String repr of a route

maybeRouteIdToRoute :: String -> Maybe Route
maybeRouteIdToRoute =
  case _ of
       "Index"                                -> Just $ Index
       "Login"                                -> Just $ Login
       "Signup"                               -> Just $ Signup
       "Secret"                               -> Just $ Secret
       "RouteExamples__Ace"                   -> Just $ RouteExamples RouteExamples__Ace
       "RouteExamples__Basic"                 -> Just $ RouteExamples RouteExamples__Basic
       "RouteExamples__Components"            -> Just $ RouteExamples RouteExamples__Components
       "RouteExamples__ComponentsInputs"      -> Just $ RouteExamples RouteExamples__ComponentsInputs
       "RouteExamples__ComponentsMultitype"   -> Just $ RouteExamples RouteExamples__ComponentsMultitype
       "RouteExamples__EffectsAffAjax"        -> Just $ RouteExamples RouteExamples__EffectsAffAjax
       "RouteExamples__EffectsEffectRandom"   -> Just $ RouteExamples RouteExamples__EffectsEffectRandom
       "RouteExamples__HigherOrderComponents" -> Just $ RouteExamples RouteExamples__HigherOrderComponents
       "RouteExamples__Interpret"             -> Just $ RouteExamples RouteExamples__Interpret
       "RouteExamples__KeyboardInput"         -> Just $ RouteExamples RouteExamples__KeyboardInput
       "RouteExamples__Lifecycle"             -> Just $ RouteExamples RouteExamples__Lifecycle
       "RouteExamples__DeeplyNested"          -> Just $ RouteExamples RouteExamples__DeeplyNested
       "RouteExamples__DynamicInput"          -> Just $ RouteExamples RouteExamples__DynamicInput
       "RouteExamples__TextNodes"             -> Just $ RouteExamples RouteExamples__TextNodes
       "RouteExamples__Lazy"                  -> Just $ RouteExamples RouteExamples__Lazy
       _                                      -> Nothing

_routeToRouteIdIso :: Lens.Iso' Route RouteId
_routeToRouteIdIso = Lens.iso to from
  where
    to :: Route -> RouteId
    to = (unsafeCoerce :: String -> RouteId) <<<
      case _ of
           Index  -> "Index"
           Login  -> "Login"
           Signup -> "Signup"
           Secret -> "Secret"
           RouteExamples routesexamples ->
             case routesexamples of
                  RouteExamples__Ace                   -> "RouteExamples__Ace"
                  RouteExamples__Basic                 -> "RouteExamples__Basic"
                  RouteExamples__Components            -> "RouteExamples__Components"
                  RouteExamples__ComponentsInputs      -> "RouteExamples__ComponentsInputs"
                  RouteExamples__ComponentsMultitype   -> "RouteExamples__ComponentsMultitype"
                  RouteExamples__EffectsAffAjax        -> "RouteExamples__EffectsAffAjax"
                  RouteExamples__EffectsEffectRandom   -> "RouteExamples__EffectsEffectRandom"
                  RouteExamples__HigherOrderComponents -> "RouteExamples__HigherOrderComponents"
                  RouteExamples__Interpret             -> "RouteExamples__Interpret"
                  RouteExamples__KeyboardInput         -> "RouteExamples__KeyboardInput"
                  RouteExamples__Lifecycle             -> "RouteExamples__Lifecycle"
                  RouteExamples__DeeplyNested          -> "RouteExamples__DeeplyNested"
                  RouteExamples__DynamicInput          -> "RouteExamples__DynamicInput"
                  RouteExamples__TextNodes             -> "RouteExamples__TextNodes"
                  RouteExamples__Lazy                  -> "RouteExamples__Lazy"

    from:: RouteId -> Route
    from (RouteId id) =
      case maybeRouteIdToRoute (NonEmptyString.toString id) of
           Just route -> route
           Nothing -> unsafeThrow $ "UNSAFE EXCEPTION: cannot convert RouteId " <> (NonEmptyString.toString id) <> " to Route"

_routeToRouteIdArrayIso :: Lens.Iso' Route RouteIdArray
_routeToRouteIdArrayIso = Lens.iso to from
  where
    to :: Route -> RouteIdArray
    to = Lens.view _routeToRouteIdIso >>> (unsafeCoerce :: RouteId -> String) >>> String.split (String.Pattern (NonEmptyString.toString routeIdSeparator)) >>> (unsafeCoerce :: Array String -> RouteIdArray)

    from:: RouteIdArray -> Route
    from = (unsafeCoerce :: RouteIdArray -> Array String) >>> String.joinWith (NonEmptyString.toString routeIdSeparator) >>> (unsafeCoerce :: String -> RouteId) >>> Lens.review _routeToRouteIdIso

type PagesRecRow a =
  ( "Index"  :: a
  , "Login"  :: a
  , "Signup" :: a
  , "Secret" :: a

  -- is using pagesRecSeparator
  , "RouteExamples.Ace"                   :: a
  , "RouteExamples.Basic"                 :: a
  , "RouteExamples.Components"            :: a
  , "RouteExamples.ComponentsInputs"      :: a
  , "RouteExamples.ComponentsMultitype"   :: a
  , "RouteExamples.EffectsAffAjax"        :: a
  , "RouteExamples.EffectsEffectRandom"   :: a
  , "RouteExamples.HigherOrderComponents" :: a
  , "RouteExamples.Interpret"             :: a
  , "RouteExamples.KeyboardInput"         :: a
  , "RouteExamples.Lifecycle"             :: a
  , "RouteExamples.DeeplyNested"          :: a
  , "RouteExamples.DynamicInput"          :: a
  , "RouteExamples.TextNodes"             :: a
  , "RouteExamples.Lazy"                  :: a
  )

type PagesRec a = Record (PagesRecRow a)

extractFromPagesRec :: forall a . Route -> PagesRec a -> a
extractFromPagesRec =
  case _ of
       Index  -> _."Index"
       Login  -> _."Login"
       Signup -> _."Signup"
       Secret -> _."Secret"
       RouteExamples routesexamples ->
         case routesexamples of
              RouteExamples__Ace                   -> _."RouteExamples.Ace"
              RouteExamples__Basic                 -> _."RouteExamples.Basic"
              RouteExamples__Components            -> _."RouteExamples.Components"
              RouteExamples__ComponentsInputs      -> _."RouteExamples.ComponentsInputs"
              RouteExamples__ComponentsMultitype   -> _."RouteExamples.ComponentsMultitype"
              RouteExamples__EffectsAffAjax        -> _."RouteExamples.EffectsAffAjax"
              RouteExamples__EffectsEffectRandom   -> _."RouteExamples.EffectsEffectRandom"
              RouteExamples__HigherOrderComponents -> _."RouteExamples.HigherOrderComponents"
              RouteExamples__Interpret             -> _."RouteExamples.Interpret"
              RouteExamples__KeyboardInput         -> _."RouteExamples.KeyboardInput"
              RouteExamples__Lifecycle             -> _."RouteExamples.Lifecycle"
              RouteExamples__DeeplyNested          -> _."RouteExamples.DeeplyNested"
              RouteExamples__DynamicInput          -> _."RouteExamples.DynamicInput"
              RouteExamples__TextNodes             -> _."RouteExamples.TextNodes"
              RouteExamples__Lazy                  -> _."RouteExamples.Lazy"

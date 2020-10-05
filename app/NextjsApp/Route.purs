module NextjsApp.Route where

import Data.Symbol
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
import Foreign.Object (Object)
import Foreign.Object as Object
import Record.ExtraSrghma as Record.ExtraSrghma
import Routing.Duplex as Routing.Duplex
import Routing.Duplex.Generic as Routing.Duplex
import Routing.Duplex.Generic.Syntax ((/))
import Type.Prelude (RProxy(..))
import Unsafe.Coerce (unsafeCoerce)

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

newtype RouteId = RouteId NonEmptyString -- e.g. "RouteExamples__Ace"

derive instance newtypeRouteId :: Newtype RouteId _
derive newtype instance eqRouteId :: Eq RouteId

routeIdToString :: RouteId -> String
routeIdToString = unsafeCoerce

newtype RouteIdArray = RouteIdArray (NonEmptyArray NonEmptyString) -- String repr of a route, e.g. ["RouteExamples", "Ace"]

derive instance newtypeRouteIdArray :: Newtype RouteIdArray _
derive newtype instance eqRouteIdArray :: Eq RouteIdArray

routeIdArrayToArrayString :: RouteIdArray -> Array String
routeIdArrayToArrayString = unsafeCoerce

-- the key is a RouteId
type RouteIdMappingRow a =
  ( "Index"  :: a
  , "Login"  :: a
  , "Signup" :: a
  , "Secret" :: a

  -- is using routeIdSeparator
  , "RouteExamples__Ace"                   :: a
  , "RouteExamples__Basic"                 :: a
  , "RouteExamples__Components"            :: a
  , "RouteExamples__ComponentsInputs"      :: a
  , "RouteExamples__ComponentsMultitype"   :: a
  , "RouteExamples__EffectsAffAjax"        :: a
  , "RouteExamples__EffectsEffectRandom"   :: a
  , "RouteExamples__HigherOrderComponents" :: a
  , "RouteExamples__Interpret"             :: a
  , "RouteExamples__KeyboardInput"         :: a
  , "RouteExamples__Lifecycle"             :: a
  , "RouteExamples__DeeplyNested"          :: a
  , "RouteExamples__DynamicInput"          :: a
  , "RouteExamples__TextNodes"             :: a
  , "RouteExamples__Lazy"                  :: a
  )

type RouteIdMapping a = Record (RouteIdMappingRow a)

-- THESE ARE THE 3 SOURCES OF TRUTH - separator and 2 *things* that define bidirectional total bijectional mapping `RouteId <-> Route`
-- EVERYTHING ELSE IS DERIVED FROM THEM

routeIdSeparator :: SProxy "__"
routeIdSeparator = SProxy

-- written as record for memoization AND to make `RouteIdMapping` total
routeIdToRouteMapping :: RouteIdMapping Route
routeIdToRouteMapping =
  { "Index":  Index
  , "Login":  Login
  , "Signup": Signup
  , "Secret": Secret

  -- is using routeIdSeparator
  , "RouteExamples__Ace":                   RouteExamples RouteExamples__Ace
  , "RouteExamples__Basic":                 RouteExamples RouteExamples__Basic
  , "RouteExamples__Components":            RouteExamples RouteExamples__Components
  , "RouteExamples__ComponentsInputs":      RouteExamples RouteExamples__ComponentsInputs
  , "RouteExamples__ComponentsMultitype":   RouteExamples RouteExamples__ComponentsMultitype
  , "RouteExamples__EffectsAffAjax":        RouteExamples RouteExamples__EffectsAffAjax
  , "RouteExamples__EffectsEffectRandom":   RouteExamples RouteExamples__EffectsEffectRandom
  , "RouteExamples__HigherOrderComponents": RouteExamples RouteExamples__HigherOrderComponents
  , "RouteExamples__Interpret":             RouteExamples RouteExamples__Interpret
  , "RouteExamples__KeyboardInput":         RouteExamples RouteExamples__KeyboardInput
  , "RouteExamples__Lifecycle":             RouteExamples RouteExamples__Lifecycle
  , "RouteExamples__DeeplyNested":          RouteExamples RouteExamples__DeeplyNested
  , "RouteExamples__DynamicInput":          RouteExamples RouteExamples__DynamicInput
  , "RouteExamples__TextNodes":             RouteExamples RouteExamples__TextNodes
  , "RouteExamples__Lazy":                  RouteExamples RouteExamples__Lazy
  }

-- written as a accessor finder to make it total bidirectional mapping / bijection
lookupFromRouteIdMapping :: forall a . Route -> RouteIdMapping a -> a
lookupFromRouteIdMapping =
  case _ of
       Index  -> _."Index"
       Login  -> _."Login"
       Signup -> _."Signup"
       Secret -> _."Secret"
       RouteExamples routesexamples ->
         case routesexamples of
              RouteExamples__Ace                   -> _."RouteExamples__Ace"
              RouteExamples__Basic                 -> _."RouteExamples__Basic"
              RouteExamples__Components            -> _."RouteExamples__Components"
              RouteExamples__ComponentsInputs      -> _."RouteExamples__ComponentsInputs"
              RouteExamples__ComponentsMultitype   -> _."RouteExamples__ComponentsMultitype"
              RouteExamples__EffectsAffAjax        -> _."RouteExamples__EffectsAffAjax"
              RouteExamples__EffectsEffectRandom   -> _."RouteExamples__EffectsEffectRandom"
              RouteExamples__HigherOrderComponents -> _."RouteExamples__HigherOrderComponents"
              RouteExamples__Interpret             -> _."RouteExamples__Interpret"
              RouteExamples__KeyboardInput         -> _."RouteExamples__KeyboardInput"
              RouteExamples__Lifecycle             -> _."RouteExamples__Lifecycle"
              RouteExamples__DeeplyNested          -> _."RouteExamples__DeeplyNested"
              RouteExamples__DynamicInput          -> _."RouteExamples__DynamicInput"
              RouteExamples__TextNodes             -> _."RouteExamples__TextNodes"
              RouteExamples__Lazy                  -> _."RouteExamples__Lazy"

---------------------

mapRouteIdMappingWithKey :: forall a b . (RouteId -> a -> b) -> RouteIdMapping a -> RouteIdMapping b
mapRouteIdMappingWithKey f mapping = (unsafeCoerce :: Object b -> RouteIdMapping b) $ Object.mapWithKey ((unsafeCoerce :: (RouteId -> a -> b) -> String -> a -> b) f) $ Object.fromHomogeneous mapping

-- |
-- | String  --stringToMaybeRoute-->  Route  <---_routeToRouteIdIso--->  RouteId  <---_routeIdToRouteIdArrayIso--->  RouteIdArray
-- |

stringToMaybeRoute :: String -> Maybe Route
stringToMaybeRoute field = Object.lookup field (Object.fromHomogeneous routeIdToRouteMapping)

stringToMaybeRouteId :: String -> Maybe RouteId
stringToMaybeRouteId = stringToMaybeRoute >>> map (Lens.view _routeToRouteIdIso)

_routeToRouteIdIso :: Lens.Iso' Route RouteId
_routeToRouteIdIso = Lens.iso to from
  where
    unsafeStringToRecordId :: String -> RouteId
    unsafeStringToRecordId string =
        case NonEmptyString.fromString string of
             Just string' -> RouteId string'
             _ -> unsafeThrow $ "unsafeStringToRecordId: expected non-empty string, but got " <> string

    -- This is smart
    reifiedRecordWhereKeyAndValueAreRecordId :: RouteIdMapping RouteId
    reifiedRecordWhereKeyAndValueAreRecordId = Record.ExtraSrghma.mapIndex unsafeStringToRecordId (RProxy :: forall type_ . RProxy (RouteIdMappingRow type_))

    -- Wow This is smart
    to :: Route -> RouteId
    to route = lookupFromRouteIdMapping route reifiedRecordWhereKeyAndValueAreRecordId

    ----------------------------
    from:: RouteId -> Route
    from (RouteId id) =
      case stringToMaybeRoute (NonEmptyString.toString id) of
           Just route -> route
           Nothing -> unsafeThrow $ "_routeToRouteIdIso -> from: impossible case, RouteId \"" <> (NonEmptyString.toString id) <> "\" is not valid, because cannot be found in routeIdToRouteMapping"

_routeIdToRouteIdArrayIso :: Lens.Iso' RouteId RouteIdArray
_routeIdToRouteIdArrayIso = Lens.iso to from
  where
    to :: RouteId -> RouteIdArray
    to = routeIdToString >>> String.split (String.Pattern (reflectSymbol routeIdSeparator)) >>> (unsafeCoerce :: Array String -> RouteIdArray)

    from:: RouteIdArray -> RouteId
    from = routeIdArrayToArrayString >>> String.joinWith (reflectSymbol routeIdSeparator) >>> (unsafeCoerce :: String -> RouteId)

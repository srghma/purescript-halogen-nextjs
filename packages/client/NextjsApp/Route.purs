module NextjsApp.Route where

import Data.Symbol (reflectSymbol)
import Effect.Exception.Unsafe (unsafeThrow)
import Protolude
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Generic.Rep.Show (genericShow)
import Data.Lens (view) as Lens
import Data.Lens.Iso (Iso', iso) as Lens
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Foreign.Object (Object)
import Foreign.Object as Object
import Record.ExtraSrghma as Record.ExtraSrghma
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
  | RouteExamples__TextNodes
  | RouteExamples__Lazy

derive instance genericRoutesExamples :: Generic RouteExamples _

derive instance eqRoutesExamples :: Eq RouteExamples

derive instance ordRoutesExamples :: Ord RouteExamples

instance showRoutesExamples :: Show RouteExamples where
  show = genericShow

instance encodeJsonRoutesExamples :: EncodeJson RouteExamples where
  encodeJson = genericEncodeJson

instance decodeJsonRoutesExamples :: DecodeJson RouteExamples where
  decodeJson = genericDecodeJson

data Route
  = Index
  | Login
  | Register
  | Secret
  | RouteExamples RouteExamples

derive instance genericRoute :: Generic Route _

derive instance eqRoute :: Eq Route

derive instance ordRoute :: Ord Route

instance showRoute :: Show Route where
  show = genericShow

instance encodeJsonRoute :: EncodeJson Route where
  encodeJson = genericEncodeJson

instance decodeJsonRoute :: DecodeJson Route where
  decodeJson = genericDecodeJson

newtype RouteId
  = RouteId NonEmptyString -- e.g. "Examples__Ace"

derive instance newtypeRouteId :: Newtype RouteId _

derive newtype instance eqRouteId :: Eq RouteId

routeIdToString :: RouteId -> String
routeIdToString = unsafeCoerce

newtype RouteIdArray
  = RouteIdArray (NonEmptyArray NonEmptyString) -- String repr of a route, e.g. ["Examples", "Ace"]

derive instance newtypeRouteIdArray :: Newtype RouteIdArray _

derive newtype instance eqRouteIdArray :: Eq RouteIdArray

routeIdArrayToArrayString :: RouteIdArray -> Array String
routeIdArrayToArrayString = unsafeCoerce

-- the key is a RouteId
type RouteIdMappingRow' a r
  = ( "Index" :: a
    , "Login" :: a
    , "Register" :: a
    , "Secret" :: a
    -- is using routeIdSeparator
    , "Examples__Ace" :: a
    , "Examples__Basic" :: a
    , "Examples__Components" :: a
    , "Examples__ComponentsInputs" :: a
    , "Examples__ComponentsMultitype" :: a
    , "Examples__EffectsAffAjax" :: a
    , "Examples__EffectsEffectRandom" :: a
    , "Examples__HigherOrderComponents" :: a
    , "Examples__Interpret" :: a
    , "Examples__KeyboardInput" :: a
    , "Examples__Lifecycle" :: a
    , "Examples__DeeplyNested" :: a
    , "Examples__TextNodes" :: a
    , "Examples__Lazy" :: a
    | r
    )

type RouteIdMappingRow a
  = RouteIdMappingRow' a ()

type RouteIdMapping a
  = Record (RouteIdMappingRow a)

-- THESE ARE THE 3 SOURCES OF TRUTH - separator and 2 *things* that define bidirectional total bijectional mapping `RouteId <-> Route`
-- EVERYTHING ELSE IS DERIVED FROM THEM
routeIdSeparator :: SProxy "__"
routeIdSeparator = SProxy

-- written as record for memoization AND to make `RouteIdMapping` total
routeIdToRouteMapping :: RouteIdMapping Route
routeIdToRouteMapping =
  { "Index": Index
  , "Login": Login
  , "Register": Register
  , "Secret": Secret
  -- is using routeIdSeparator
  , "Examples__Ace": RouteExamples RouteExamples__Ace
  , "Examples__Basic": RouteExamples RouteExamples__Basic
  , "Examples__Components": RouteExamples RouteExamples__Components
  , "Examples__ComponentsInputs": RouteExamples RouteExamples__ComponentsInputs
  , "Examples__ComponentsMultitype": RouteExamples RouteExamples__ComponentsMultitype
  , "Examples__EffectsAffAjax": RouteExamples RouteExamples__EffectsAffAjax
  , "Examples__EffectsEffectRandom": RouteExamples RouteExamples__EffectsEffectRandom
  , "Examples__HigherOrderComponents": RouteExamples RouteExamples__HigherOrderComponents
  , "Examples__Interpret": RouteExamples RouteExamples__Interpret
  , "Examples__KeyboardInput": RouteExamples RouteExamples__KeyboardInput
  , "Examples__Lifecycle": RouteExamples RouteExamples__Lifecycle
  , "Examples__DeeplyNested": RouteExamples RouteExamples__DeeplyNested
  , "Examples__TextNodes": RouteExamples RouteExamples__TextNodes
  , "Examples__Lazy": RouteExamples RouteExamples__Lazy
  }

-- written as a accessor finder to make it total bidirectional mapping / bijection
lookupFromRouteIdMapping :: forall a. Route -> RouteIdMapping a -> a
lookupFromRouteIdMapping = case _ of
  Index -> _."Index"
  Login -> _."Login"
  Register -> _."Register"
  Secret -> _."Secret"
  RouteExamples routesexamples -> case routesexamples of
    RouteExamples__Ace -> _."Examples__Ace"
    RouteExamples__Basic -> _."Examples__Basic"
    RouteExamples__Components -> _."Examples__Components"
    RouteExamples__ComponentsInputs -> _."Examples__ComponentsInputs"
    RouteExamples__ComponentsMultitype -> _."Examples__ComponentsMultitype"
    RouteExamples__EffectsAffAjax -> _."Examples__EffectsAffAjax"
    RouteExamples__EffectsEffectRandom -> _."Examples__EffectsEffectRandom"
    RouteExamples__HigherOrderComponents -> _."Examples__HigherOrderComponents"
    RouteExamples__Interpret -> _."Examples__Interpret"
    RouteExamples__KeyboardInput -> _."Examples__KeyboardInput"
    RouteExamples__Lifecycle -> _."Examples__Lifecycle"
    RouteExamples__DeeplyNested -> _."Examples__DeeplyNested"
    RouteExamples__TextNodes -> _."Examples__TextNodes"
    RouteExamples__Lazy -> _."Examples__Lazy"

---------------------
mapRouteIdMappingWithKey :: forall a b. (RouteId -> a -> b) -> RouteIdMapping a -> RouteIdMapping b
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
  unsafeStringToRecordId string = case NonEmptyString.fromString string of
    Just string' -> RouteId string'
    _ -> unsafeThrow $ "unsafeStringToRecordId: expected non-empty string, but got " <> string

  -- This is smart
  reifiedRecordWhereKeyAndValueAreRecordId :: RouteIdMapping RouteId
  reifiedRecordWhereKeyAndValueAreRecordId = Record.ExtraSrghma.mapIndex unsafeStringToRecordId (RProxy :: forall type_. RProxy (RouteIdMappingRow type_))

  -- Wow This is smart
  to :: Route -> RouteId
  to route = lookupFromRouteIdMapping route reifiedRecordWhereKeyAndValueAreRecordId

  ----------------------------
  from :: RouteId -> Route
  from (RouteId id) = case stringToMaybeRoute (NonEmptyString.toString id) of
    Just route -> route
    Nothing -> unsafeThrow $ "_routeToRouteIdIso -> from: impossible case, RouteId \"" <> (NonEmptyString.toString id) <> "\" is not valid, because cannot be found in routeIdToRouteMapping"

_routeIdToRouteIdArrayIso :: Lens.Iso' RouteId RouteIdArray
_routeIdToRouteIdArrayIso = Lens.iso to from
  where
  to :: RouteId -> RouteIdArray
  to = routeIdToString >>> String.split (String.Pattern (reflectSymbol routeIdSeparator)) >>> (unsafeCoerce :: Array String -> RouteIdArray)

  from :: RouteIdArray -> RouteId
  from = routeIdArrayToArrayString >>> String.joinWith (reflectSymbol routeIdSeparator) >>> (unsafeCoerce :: String -> RouteId)

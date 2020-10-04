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
import Foreign.Object as Object
import Record.ExtraSrghma as Record.ExtraSrghma
import Routing.Duplex (RouteDuplex', root) as Routing.Duplex
import Routing.Duplex.Generic (noArgs, sum) as Routing.Duplex
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

--- THESE ARE THE 3 SOURCES OF TRUTH - separator and 2 *things* that define bidirectional mapping

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

-- | cannot replace this with `Map Route RouteId`, because this WILL NOT be type safe / total mapping
-- | would LIKE to replace this with record
-- |
-- | TODO: derive from `routeIdToRouteMapping`
routeToRouteId :: Route -> RouteId
routeToRouteId = (unsafeCoerce :: String -> RouteId) <<<
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

---------------------

-- EVERYTHING ELSE IS DERIVED FROM THEM

-- |
-- | String  --stringToMaybeRoute-->  Route  <---_routeToRouteIdIso--->  RouteId  <---_routeIdToRouteIdArrayIso--->  RouteIdArray
-- |

stringToMaybeRoute :: String -> Maybe Route
stringToMaybeRoute field = Object.lookup field (Object.fromHomogeneous routeIdToRouteMapping)

stringToMaybeRouteId :: String -> Maybe RouteId
stringToMaybeRouteId = stringToMaybeRoute >>> map (Lens.view _routeToRouteIdIso)

_routeToRouteIdIso :: Lens.Iso' Route RouteId
_routeToRouteIdIso = Lens.iso routeToRouteId from
  where
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

---------------------------------

lookupFromRouteIdMapping :: forall a . Route -> RouteIdMapping a -> a
lookupFromRouteIdMapping route routeIdToTmthingMapping =
  let
    (field :: String) = routeIdToString $ routeToRouteId route
  in case Object.lookup field (Object.fromHomogeneous routeIdToTmthingMapping) of
          Just a -> a
          _ -> unsafeThrow $ "lookupFromRouteIdMapping: impossible case, routeToRouteId function is not total, becuase field \"" <> field <> "\" cannot be found in given routeIdToTmthingMapping"

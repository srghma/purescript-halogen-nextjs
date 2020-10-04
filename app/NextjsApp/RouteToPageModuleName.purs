module NextjsApp.RouteToPageModuleName where

import ModuleName
import Prim.RowList
import Protolude
import Record.Extra
import Type.Data.RowList

import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Nextjs.Page as Nextjs.Page
import NextjsApp.Route (RouteIdMapping, RouteIdMappingRow, Route, RouteId, RouteIdArray)
import NextjsApp.Route as NextjsApp.Route
import Record.Homogeneous as Record.Homogeneous
import Type.Prelude (RProxy(..))
import Data.Symbol
import Data.Lens as Lens
import Data.Lens.Iso as Lens
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Unsafe.Coerce (unsafeCoerce)
import Data.Newtype

-- | SOURCE OF TRUTH
-- | everything else is derived
pagesModuleNamePrefix :: NonEmptyArray NonEmptyString
pagesModuleNamePrefix = unsafeCoerce ["NextjsApp", "Pages"]

----------------------------------

routeIdToModuleName ::RouteId -> ModuleName
routeIdToModuleName = (Lens.view NextjsApp.Route._routeIdToRouteIdArrayIso :: RouteId -> RouteIdArray) >>> (unwrap :: RouteIdArray -> NonEmptyArray NonEmptyString) >>> \x -> pagesModuleNamePrefix <> x

-- | Will map
-- |
-- | ```purs
-- | RProxy
-- |   ( "PageNamespace.PageName" :: anyType
-- |   )
-- | ```
-- |
-- | to
-- |
-- | ```purs
-- | { "PageNamespace.PageName" :: ModuleName [ "PageNamespace", "PageName" ]
-- | }
-- | ```
pagesToModuleNameRec :: RouteIdMapping ModuleName
pagesToModuleNameRec = Record.Homogeneous.mapIndex unsafeModuleNameFromString (RProxy :: forall type_ . RProxy (RouteIdMappingRow type_))
  where
    unsafeModuleNameFromString :: String -> ModuleName
    unsafeModuleNameFromString = String.split (String.Pattern (reflectSymbol NextjsApp.Route.routeIdSeparator)) >>> append pagesModuleNamePrefix >>> unsafeModuleName

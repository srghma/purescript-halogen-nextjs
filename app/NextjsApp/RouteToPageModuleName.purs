module NextjsApp.RouteToPageModuleName where

import Data.Newtype
import Data.Symbol
import ModuleName
import Prim.RowList
import Protolude
import Record.Extra
import Type.Data.RowList

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Lens as Lens
import Data.Lens.Iso as Lens
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Nextjs.Page as Nextjs.Page
import NextjsApp.Route (Route, RouteId, RouteIdArray, RouteIdMapping, RouteIdMappingRow, _routeToRouteIdIso, routeIdToRouteMapping)
import NextjsApp.Route as NextjsApp.Route
import Record.Extra as Record.Extra
import Record.ExtraSrghma as Record.ExtraSrghma
import Record.Homogeneous as Record.Homogeneous
import Type.Prelude (RProxy(..))
import Unsafe.Coerce (unsafeCoerce)

-- | SOURCE OF TRUTH
-- | everything else is derived
pagesModuleNamePrefix :: NonEmptyArray NonEmptyString
pagesModuleNamePrefix = unsafeCoerce ["NextjsApp", "Pages"]

----------------------------------

pagesToModuleNameRec :: RouteIdMapping ModuleName
pagesToModuleNameRec = Record.Extra.mapRecord (Lens.view _routeToRouteIdIso >>> routeIdToModuleName) routeIdToRouteMapping
  where
    routeIdToModuleName ::RouteId -> ModuleName
    routeIdToModuleName = (Lens.view NextjsApp.Route._routeIdToRouteIdArrayIso :: RouteId -> RouteIdArray) >>> (unwrap :: RouteIdArray -> NonEmptyArray NonEmptyString) >>> (\x -> pagesModuleNamePrefix <> x) >>> wrap

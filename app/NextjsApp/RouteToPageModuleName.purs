module NextjsApp.RouteToPageModuleName where

import ModuleName
import Prim.RowList
import Protolude
import Record.Extra
import Type.Data.RowList

import Data.String as String
import Nextjs.Page as Nextjs.Page
import NextjsApp.Route (PagesRec, PagesRecRow, Route)
import NextjsApp.Route as NextjsApp.Route
import Record.Homogeneous as Record.Homogeneous
import Type.Prelude (RProxy(..))

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
-- | [ "PageNamespace.PageName" ]
-- | ```
pagesKeys :: forall rowList type_ . RowToList (PagesRecRow type_) rowList => Keys rowList => List String
pagesKeys = keysImpl (RLProxy :: RLProxy rowList)

unsafeModuleNameFromString :: String -> ModuleName
unsafeModuleNameFromString = String.split (String.Pattern NextjsApp.Route.pagesRecSeparator) >>> unsafeModuleName

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
pagesRec :: PagesRec ModuleName
pagesRec = Record.Homogeneous.mapIndex unsafeModuleNameFromString (RProxy :: forall type_ . RProxy (PagesRecRow type_))

routeToPage :: Route -> ModuleName
routeToPage route = NextjsApp.Route.extractFromPagesRec route pagesRec

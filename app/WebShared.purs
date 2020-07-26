module Nextjs.WebShared where

import Protolude

import Data.Argonaut.Core (Json) as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Either (hush)
import Effect.Aff as Effect.Aff
import Halogen as H
import Halogen.Aff.Util as Halogen.Aff.Util
import Halogen.VDom.Driver as Halogen.VDom.Driver
import Nextjs.AppM (Env, runAppM)
import Nextjs.Constants as Nextjs.Constants
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Lib.Utils (findJsonFromScriptElement, getPathWithoutOrigin)
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.PageLoader as Nextjs.PageLoader
import Nextjs.Route as Nextjs.Route
import Nextjs.Router as Nextjs.Router
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Web.DOM as Web.DOM
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.Window as Web.HTML.Window
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import FRP.Event as FRP.Event
import Web.HTML.HTMLHeadElement as Web.HTML.HTMLHeadElement

getHtmlEntities
  :: Effect
    { window :: Web.HTML.Window.Window
    , document :: Web.HTML.HTMLDocument
    , body :: Web.HTML.HTMLElement
    , head :: Web.HTML.HTMLHeadElement
    }
getHtmlEntities = do
  (window :: Web.HTML.Window.Window) <- Web.HTML.window
  (document :: Web.HTML.HTMLDocument) <- Web.HTML.Window.document window
  (body :: Web.HTML.HTMLElement) <- Web.HTML.HTMLDocument.body document >>= maybe (throwError $ error "Cannot find body") pure
  (head :: Web.HTML.HTMLHeadElement) <- do
     (head :: Web.HTML.HTMLElement) <- Web.HTML.HTMLDocument.head document >>= maybe (throwError $ error "Cannot find head") pure
     Web.HTML.HTMLHeadElement.fromHTMLElement head # maybe (throwError $ error "not head") pure
  pure { window, document, body, head }

module Nextjs.WebShared where

import Protolude

import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.Window as Web.HTML.Window
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

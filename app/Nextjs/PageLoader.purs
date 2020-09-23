module Nextjs.PageLoader where

import Protolude

import Data.Array as Array
import Effect.Aff as Aff
import Effect.Uncurried as EFn
import FRP.Event as Event
import Halogen.VDom.Util (unsafeSetAny) as Halogen.VDom.Util
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Route as Nextjs.Route
import Web.DOM as Web.DOM
import Web.DOM.Document as Web.DOM.Document
import Web.DOM.Node as Web.DOM.Node
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.HTML.HTMLHeadElement as Web.HTML.HTMLHeadElement
import Web.HTML.HTMLLinkElement as Web.HTML.HTMLLinkElement
import Web.HTML.HTMLScriptElement as Web.HTML.HTMLScriptElement

-- https://github.com/vercel/next.js/blob/7dbdf1d89eef004170d8f2661b4b3c299962b1f8/packages/next/client/page-loader.js#L177

type PageInfo =
  { pageName :: String
  , page :: Nextjs.Lib.Page.Page
  }
type PageCache = Array PageInfo
type PageRegisteredEvent = Event.Event PageInfo

foreign import readPageCache :: Effect PageCache
foreign import _setRegisterEventOnPageCacheBus :: EFn.EffectFn1 (EFn.EffectFn1 PageInfo Unit) Unit
foreign import supportedPrefetchRel :: String

findPageInCache :: Nextjs.Route.Route -> PageCache -> Maybe PageInfo
findPageInCache route = Array.find (\info -> info.pageName == Nextjs.Route.routeToPageManifestId route)

-- should be called only once
createPageRegisteredEvent :: Effect PageRegisteredEvent
createPageRegisteredEvent = do
  eventIO <- Event.create
  EFn.runEffectFn1 _setRegisterEventOnPageCacheBus (EFn.mkEffectFn1 eventIO.push)
  pure eventIO.event

scriptElementSetOnError :: Effect Unit -> Web.HTML.HTMLScriptElement -> Effect Unit
scriptElementSetOnError = EFn.runEffectFn3 Halogen.VDom.Util.unsafeSetAny "onerror"

linkElementSetAs :: String -> Web.HTML.HTMLLinkElement -> Effect Unit
linkElementSetAs = EFn.runEffectFn3 Halogen.VDom.Util.unsafeSetAny "as"

createScriptElement :: Web.DOM.Document -> Effect Web.HTML.HTMLScriptElement
createScriptElement document = do
  (element :: Web.DOM.Element) <- Web.DOM.Document.createElement "script" document
  Web.HTML.HTMLScriptElement.fromElement element # maybe (throwError $ error "not Web.HTML.HTMLScriptElement") pure

createLinkElement :: Web.DOM.Document -> Effect Web.HTML.HTMLLinkElement
createLinkElement document = do
  (element :: Web.DOM.Element) <- Web.DOM.Document.createElement "link" document
  Web.HTML.HTMLLinkElement.fromElement element # maybe (throwError $ error "not Web.HTML.HTMLLinkElement") pure

elemIsPresent :: String -> Web.DOM.ParentNode -> Effect Boolean
elemIsPresent query parentNode = Web.DOM.ParentNode.querySelector (Web.DOM.ParentNode.QuerySelector query) parentNode <#> isJust

-----------------------------

-- from https://github.com/vercel/next.js/blob/eead55cbaf278dfaa4eda9d055eb1042ec5dc535/packages/next/client/page-loader.js#L235
isJsAlreadyAdded :: Web.HTML.HTMLElement -> String -> Effect Boolean
isJsAlreadyAdded body url = elemIsPresent ("script[src=\"" <> url <> "\"]") (Web.HTML.HTMLElement.toParentNode body)

-- from https://github.com/vercel/next.js/blob/bef9b5610911532689dc251b7ceac72985e6b6dd/packages/next/client/page-loader.js#L260
appendJs :: Web.DOM.Document -> Web.HTML.HTMLElement -> String -> Effect Unit
appendJs document body url = do
  (scriptElement :: Web.HTML.HTMLScriptElement) <- createScriptElement document
  Web.HTML.HTMLScriptElement.setSrc url scriptElement
  scriptElementSetOnError (throwError $ error $ "cannot load " <> url) scriptElement
  void $ Web.DOM.Node.appendChild (Web.HTML.HTMLScriptElement.toNode scriptElement) (Web.HTML.HTMLElement.toNode body)

-----------------------------

-- TODO: refactor
isJsPreloadAlreadyAdded :: Web.HTML.HTMLHeadElement -> String -> Effect Boolean
isJsPreloadAlreadyAdded head url = do
  prefetch <- elemIsPresent prefetchQuery parent
  if prefetch
    then pure true
    else elemIsPresent preloadQuery parent
  where
    parent = Web.HTML.HTMLHeadElement.toParentNode head
    prefetchQuery = "link[rel=prefetch][as=script][href=\"" <> url <> "\"]"
    preloadQuery = "link[rel=preload][as=script][href=\"" <> url <> "\"]"

appendJsPrefetch :: Web.DOM.Document -> Web.HTML.HTMLHeadElement -> String -> Effect Unit
appendJsPrefetch document head url = do
  (linkElement :: Web.HTML.HTMLLinkElement) <- createLinkElement document
  Web.HTML.HTMLLinkElement.setRel supportedPrefetchRel linkElement
  linkElementSetAs "script" linkElement
  Web.HTML.HTMLLinkElement.setHref url linkElement
  void $ Web.DOM.Node.appendChild (Web.HTML.HTMLLinkElement.toNode linkElement) (Web.HTML.HTMLHeadElement.toNode head)

-----------------------------

-- from https://github.com/vercel/next.js/blob/eead55cbaf278dfaa4eda9d055eb1042ec5dc535/packages/next/client/page-loader.js#L241
isCssAlreadyAdded :: Web.HTML.HTMLHeadElement -> String -> Effect Boolean
isCssAlreadyAdded head url = elemIsPresent ("link[rel=stylesheet][href=\"" <> url <> "\"]") (Web.HTML.HTMLHeadElement.toParentNode head)

appendCss :: Web.DOM.Document -> Web.HTML.HTMLHeadElement -> String -> Effect Unit
appendCss document head url = do
  (linkElement :: Web.HTML.HTMLLinkElement) <- createLinkElement document
  Web.HTML.HTMLLinkElement.setRel "stylesheet" linkElement
  Web.HTML.HTMLLinkElement.setHref url linkElement
  void $ Web.DOM.Node.appendChild (Web.HTML.HTMLLinkElement.toNode linkElement) (Web.HTML.HTMLHeadElement.toNode head)

-----------------------------

appendPage :: Nextjs.Manifest.PageManifest.PageManifest -> Web.HTML.HTMLDocument -> Web.HTML.HTMLElement -> Web.HTML.HTMLHeadElement -> Effect Unit
appendPage pageManifest document body head = do
  let document' = Web.HTML.HTMLDocument.toDocument document
  -- add js to body if not yet added
  for_ pageManifest.js \url ->
    unlessM (isJsAlreadyAdded body url) $ do
       traceM $ "addPageScriptsToBodyIfNotYetAdded: appending " <> url
       appendJs document' body url
  -- add css to head if not yet added
  for_ pageManifest.css \url ->
    unlessM (isCssAlreadyAdded head url) $ do
       traceM $ "addPageScriptsToBodyIfNotYetAdded: appending " <> url
       appendCss document' head url

appendPagePrefetch :: Nextjs.Manifest.PageManifest.PageManifest -> Web.HTML.HTMLDocument -> Web.HTML.HTMLHeadElement -> Effect Unit
appendPagePrefetch pageManifest document head = do
  let document' = Web.HTML.HTMLDocument.toDocument document
  for_ pageManifest.js \url ->
    unlessM (isJsPreloadAlreadyAdded head url) $ do
       traceM $ "addPageScriptsToBodyIfNotYetAdded: appending " <> url
       appendJsPrefetch document' head url
  for_ pageManifest.css \url ->
    unlessM (isCssAlreadyAdded head url) $ do
       traceM $ "addPageScriptsToBodyIfNotYetAdded: appending " <> url
       appendCss document' head url

loadPage :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest -> Web.HTML.HTMLDocument -> Web.HTML.HTMLElement -> Web.HTML.HTMLHeadElement -> PageRegisteredEvent -> Nextjs.Route.Route -> Aff Nextjs.Lib.Page.Page
loadPage clientPagesManifest document body head pageRegisteredEvent route = do
  pageCache <- liftEffect readPageCache

  liftEffect $ appendPage (Nextjs.Route.extractFromPagesRec route clientPagesManifest) document body head

  case findPageInCache route pageCache of
    Just info -> pure info.page

    -- TODO
    -- how to always "unsubscribe" on completion (mainly on "resolve")?
    -- the "Aff.supervise" doesn't help
    Nothing -> Aff.makeAff \resolve -> do
      unsubscribe <- Event.subscribe pageRegisteredEvent \info -> do
        if info.pageName == routeId
          then resolve $ Right info.page
          else pure unit
      pure $ Aff.effectCanceler unsubscribe
  where
    routeId = Nextjs.Route.routeToPageManifestId route

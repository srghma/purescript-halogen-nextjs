module Nextjs.AppM where

import Protolude

import Control.Monad.Reader
import Nextjs.Capability.Navigate

import Data.Array as Array
import Halogen as H
import Foreign as Foreign
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Type.Equality (class TypeEquals, from)
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import FRP.Event as FRP.Event
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Halogen.VDom.Util as Halogen.VDom.Util
import Data.Function.Uncurried as Fn
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Web.HTML as Web.HTML

type Env =
  { pushStateInterface :: Routing.PushState.PushStateInterface
  , intersectionObserver :: Web.IntersectionObserver.IntersectionObserver
  , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
  , clientPagesManifest :: Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  , document :: Web.HTML.HTMLDocument
  , head :: Web.HTML.HTMLHeadElement
  }

newtype AppM a = AppM (ReaderT Env Aff a)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from

instance navigateAppM :: Navigate AppM where
  navigate route = do
    let path = Routing.Duplex.print Nextjs.Route.routeCodec route
    (env :: Env) <- ask
    liftEffect $ env.pushStateInterface.pushState (Foreign.unsafeToForeign unit) path

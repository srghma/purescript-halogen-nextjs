module Nextjs.AppM where

import Protolude

import Control.Monad.Reader (ReaderT, asks, runReaderT)
import Effect (Effect)
import FRP.Event as FRP.Event
import Foreign as Foreign
import Halogen as H
import Nextjs.Link.Types as Nextjs.Link.Types
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Route as Nextjs.Route
import Routing.Duplex as Routing.Duplex
import Routing.PushState as Routing.PushState
import Type.Equality (class TypeEquals, from)
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML as Web.HTML
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry

type EnvLinkHandleActions =
  { handleInitialize       :: H.HalogenM Nextjs.Link.Types.State Nextjs.Link.Types.Action () Void AppM Unit
  , handleFinalize         :: H.HalogenM Nextjs.Link.Types.State Nextjs.Link.Types.Action () Void AppM Unit
  , handleLinkIsInViewport :: H.SubscriptionId -> H.HalogenM Nextjs.Link.Types.State Nextjs.Link.Types.Action () Void AppM Unit
  }

type Env =
  { navigate :: Nextjs.Route.Route -> Effect Unit
  , linkHandleActions :: EnvLinkHandleActions
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

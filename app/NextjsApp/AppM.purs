module NextjsApp.AppM where

import Protolude

import Control.Monad.Reader (ReaderT, asks, runReaderT)
import Halogen as H
import NextjsApp.Link.Types as NextjsApp.Link.Types
import NextjsApp.Route as NextjsApp.Route
import Type.Equality (class TypeEquals, from)

type EnvLinkHandleActions =
  { handleInitialize       :: H.HalogenM NextjsApp.Link.Types.State NextjsApp.Link.Types.Action () Void AppM Unit
  , handleLinkIsInViewport :: H.SubscriptionId -> H.HalogenM NextjsApp.Link.Types.State NextjsApp.Link.Types.Action () Void AppM Unit
  }

type Env =
  { navigate :: NextjsApp.Route.Route -> Effect Unit
  , linkHandleActions :: EnvLinkHandleActions -- TODO: this thing doesn't make sense for mobile, only for client
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

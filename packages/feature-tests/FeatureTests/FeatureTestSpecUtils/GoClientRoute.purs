module FeatureTests.FeatureTestSpecUtils.GoClientRoute where

import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Control.Monad.Rec.Class
import Data.Identity
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import Protolude
import Test.Spec
import Unsafe.Coerce

import Data.Functor.Variant (FProxy(..))
import Effect.Ref as Ref
import Lunapark as Lunapark
import NextjsApp.Route (Route)
import NextjsApp.RouteDuplexCodec as NextjsApp.RouteDuplexCodec
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Routing.Duplex as Routing.Duplex
import Run as Run
import FeatureTests.FeatureTestSpecUtils.Lunapark (runLunapark)

goClientRoute
  :: ∀ r m
   . MonadAff m
  => MonadAsk { clientRootUrl :: String, interpreter :: Lunapark.Interpreter () | r } m
  => MonadThrow Error m
  => Route
  -> m Unit
goClientRoute route = ask >>= \config -> runLunapark $ Lunapark.go $ config.clientRootUrl <> Routing.Duplex.print NextjsApp.RouteDuplexCodec.routeCodec route

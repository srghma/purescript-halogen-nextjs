module FeatureTests.FeatureTestSpecUtils.GoClientRoute where

import Protolude
import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Data.Maybe
import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import Test.Spec
import Unsafe.Coerce
import FeatureTests.FeatureTestSpec
import Run (Run)
import Run as Run
import Run.Reader as Run
import Lunapark as Lunapark
import Node.Process as Node.Process
import Node.Encoding as Node.Encoding
import Node.Stream as Node.Stream
import Effect.Ref as Ref
import Control.Monad.Rec.Class
import Node.ReadLine as Node.ReadLine
import NextjsApp.RouteDuplexCodec as NextjsApp.RouteDuplexCodec
import Routing.Duplex as Routing.Duplex

goClientRoute route =
  Run.ask >>=
  \{ clientRootUrl } -> Lunapark.go $ clientRootUrl <> Routing.Duplex.print NextjsApp.RouteDuplexCodec.routeCodec route

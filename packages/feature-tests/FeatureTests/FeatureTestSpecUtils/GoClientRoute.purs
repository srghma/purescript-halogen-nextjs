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
import Run (Run)
import Run as Run
import Run.Reader as Run

goClientRoute' clientRootUrl route = Lunapark.go $ clientRootUrl <> Routing.Duplex.print NextjsApp.RouteDuplexCodec.routeCodec route

------------------------

data GoClientRouteF a
  = GoClientRoute Route a

derive instance functorGoClientRouteF :: Functor GoClientRouteF

type GO_CLIENT_ROUTE = FProxy GoClientRouteF

_goClientRoute = SProxy :: SProxy "goClientRoute"

goClientRoute :: forall r. Route -> Run (goClientRoute :: GO_CLIENT_ROUTE | r) Unit
goClientRoute route = Run.lift _goClientRoute (GoClientRoute route unit)

type GoClientRouteEffect r = ( goClientRoute :: GO_CLIENT_ROUTE | r )

handleGoClientRoute
  :: forall r
   . String
  -> GoClientRouteF
  ~> Run
     (
     | Lunapark.LunaparkEffect
     + Lunapark.BaseEffects
     + r
     )
handleGoClientRoute clientRootUrl = case _ of
  GoClientRoute route next -> do
    goClientRoute' clientRootUrl route
    pure next

runGoClientRoute
  :: forall r
   . String
  -> Run
     (
     | Lunapark.LunaparkEffect
     + Lunapark.BaseEffects
     + GoClientRouteEffect
     + r
     )
  ~> Run
     (
     | Lunapark.LunaparkEffect
     + Lunapark.BaseEffects
     + r
     )
runGoClientRoute clientRootUrl = Run.interpret (Run.on _goClientRoute (handleGoClientRoute clientRootUrl) Run.send)

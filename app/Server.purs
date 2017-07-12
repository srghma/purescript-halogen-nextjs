module Nextjs.Server where

import Protolude

import Affjax as Affjax
import Ansi.Codes (Color(..)) as Ansi
import Ansi.Output (foreground, withGraphics) as Ansi
import Control.Monad.Indexed.Qualified as IndexedMonad
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Encode as ArgonautCodecs
import Data.String.Yarn as Yarn
import Effect.Class.Console as Console
import Halogen.HTML as Halogen.HTML
import Hyper.Conn (Conn) as Hyper
import Hyper.Middleware (Middleware, lift') as Hyper
import Hyper.Node.FileServer (fileServer) as Hyper.Node
import Hyper.Node.Server (HttpRequest, HttpResponse, Port(..), defaultOptionsWithLogging, runServer) as Hyper.Node
import Hyper.Request (getRequestData) as Hyper
import Hyper.Response (ResponseEnded, StatusLineOpen, closeHeaders, respond, writeStatus) as Hyper
import Hyper.Status (statusBadRequest, statusOK) as Hyper
import Nextjs.Lib.Api as Nextjs.Lib.Api
import Nextjs.Lib.Page as Nextjs.Lib.Page
import Nextjs.Lib.RenderComponent as Nextjs.Lib.RenderComponent
import Nextjs.Route as Nextjs.Route
import Nextjs.RouteToPage as Nextjs.RouteToPage
import Nextjs.Manifest.ServerBuildManifest as Nextjs.Manifest.ServerBuildManifest
import Nextjs.Manifest.PageManifest as Nextjs.Manifest.PageManifest
import Nextjs.Server.Config as Nextjs.Server.Config
import Nextjs.Server.PageTemplate as Nextjs.Server.PageTemplate
import Node.Globals as NodeProcess.Globals
import Node.Path as NodePath
import Options.Applicative as Options.Applicative
import Protolude.Node as Protolude.Node
import Routing.Duplex as Routing.Duplex
import Routing.Duplex.Parser as Routing.Duplex
import Nextjs.Manifest.ClientPagesManifest as Nextjs.Manifest.ClientPagesManifest
import Nextjs.Router as Nextjs.Router

data StaticOrDynamicPageData input
  = StaticPageData input
  | DynamicPageData { input :: input, encoder :: input -> ArgonautCore.Json }

renderPage
  :: forall c input
   . Nextjs.Route.Route
  -> Nextjs.Manifest.ClientPagesManifest.ClientPagesManifest
  -> Nextjs.Manifest.PageManifest.PageManifest
  -> Nextjs.Lib.Page.PageSpec input
  -> Hyper.Middleware
     Aff
     (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) c)
     (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) c)
     Unit
renderPage route clientPagesManifest pageManifest page = IndexedMonad.do
  (response :: Either Nextjs.Lib.Api.ApiError (StaticOrDynamicPageData input)) <-
    case page.pageData of
      (Nextjs.Lib.Page.DynamicPageData pageData) -> Hyper.lift' do
         (response :: Either Affjax.Error (Affjax.Response ArgonautCore.Json)) <- pageData.request
         let (decodedResponse :: Either Nextjs.Lib.Api.ApiError input) = Nextjs.Lib.Api.tryDecodeResponse pageData.codec.decoder response -- yes, we decode and then again encode
         pure $ map (\input -> DynamicPageData { input, encoder: pageData.codec.encoder }) decodedResponse
      (Nextjs.Lib.Page.StaticPageData pageData) -> pure $ Right $ StaticPageData pageData

  case response of
    Left (Nextjs.Lib.Api.ApiAffjaxError error) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond $ Yarn.unlines
        [ "Cannot reach api:"
        , "  " <> Affjax.printError error
        ]
    Left (Nextjs.Lib.Api.ApiJsonDecodeError error json) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond $ Yarn.unlines
        [ "Cannot decode response:"
        , "  error = " <> ArgonautCodecs.printJsonDecodeError error
        , "  json = " <> ArgonautCore.stringify json
        ]
    Right pageData -> IndexedMonad.do
      let
        routerInput :: input -> Nextjs.Router.ServerState ()
        routerInput input =
          { currentPageInfo: Just { route, pageSpecWithInputBoxed: Nextjs.Lib.Page.mkPageSpecWithInputBoxed { input, component: page.component, title: page.title } }
          }

        component :: String
        component =
          case pageData of
               StaticPageData input -> Nextjs.Lib.RenderComponent.renderComponent Nextjs.Router.serverComponent (routerInput input)
               DynamicPageData { input } -> Nextjs.Lib.RenderComponent.renderComponent Nextjs.Router.serverComponent (routerInput input)

        pageData' :: Nextjs.Server.PageTemplate.StaticOrDynamicPageData
        pageData' =
          case pageData of
               StaticPageData _ -> Nextjs.Server.PageTemplate.StaticPageData
               DynamicPageData { input, encoder } -> Nextjs.Server.PageTemplate.DynamicPageData (encoder input)

        pageRendered :: String
        pageRendered = Nextjs.Server.PageTemplate.pageTemplate clientPagesManifest pageManifest { title: page.title, component, pageData: pageData' }
      Hyper.writeStatus Hyper.statusOK
      Hyper.closeHeaders
      Hyper.respond pageRendered

app
  :: ∀ c
   . Nextjs.Manifest.ServerBuildManifest.BuildManifest
  -> Hyper.Middleware
    Aff
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) c)
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) c)
    Unit
app buildManifest = IndexedMonad.do
  request <- Hyper.getRequestData

  case Routing.Duplex.parse Nextjs.Route.routeCodec request.url of
    Left (error :: Routing.Duplex.RouteError) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond $ "Cannot find route: " <> show error
    Right route -> IndexedMonad.do
      Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightYellow) $ "  Page requested: " <> show route

      let pageManifest = Nextjs.Route.extractFromPagesRec route buildManifest.pages
      let mergedPageManifest = Nextjs.Manifest.PageManifest.mergePageManifests buildManifest.main pageManifest

      Nextjs.Lib.Page.unPage (renderPage route buildManifest.pages mergedPageManifest) (Nextjs.RouteToPage.routeToPage route)

main :: Effect Unit
main = launchAff_ do
  config <- liftEffect $ Options.Applicative.execParser Nextjs.Server.Config.opts

  buildManifest <- liftEffect $ Nextjs.Manifest.ServerBuildManifest.getBuildManifest config

  Protolude.Node.filePathExistsAndIsDir config.rootPath >>=
    if _
      then Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using static files dir: " <> config.rootPath
      else Protolude.Node.exitWith 1 $ "Could not find static files dir: " <> config.rootPath

  liftEffect $ Hyper.Node.runServer
    (Hyper.Node.defaultOptionsWithLogging { port = Hyper.Node.Port config.port })
    {}
    (app buildManifest # Hyper.Node.fileServer config.rootPath)

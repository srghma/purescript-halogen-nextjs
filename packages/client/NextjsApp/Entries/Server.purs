module NextjsApp.Entries.Server where

import PathyExtra (printPathPosixSandboxAny)
import Protolude
import Affjax as Affjax
import Ansi.Codes as Ansi
import Ansi.Output as Ansi
import Control.Monad.Indexed.Qualified as IndexedMonad
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.String.Yarn as Yarn
import Effect.Class.Console as Console
import Hyper.Conn as Hyper
import Hyper.Middleware as Hyper
import Hyper.Node.FileServer as Hyper.Node
import Hyper.Node.Server as Hyper.Node
import Hyper.Request as Hyper
import Hyper.Response as Hyper
import Hyper.Status as Hyper
import Nextjs.Api as Nextjs.Api
import Nextjs.Page as Nextjs.Page
import Nextjs.RenderComponent as Nextjs.RenderComponent
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import NextjsApp.Manifest.ServerBuildManifest as NextjsApp.Manifest.ServerBuildManifest
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.RouteToPageNonClient as NextjsApp.RouteToPageNonClient
import NextjsApp.Router.Server as NextjsApp.Router
import NextjsApp.Router.Shared as NextjsApp.Router
import NextjsApp.Server.Config as NextjsApp.Server.Config
import NextjsApp.Server.PageTemplate as NextjsApp.Server.PageTemplate
import Node.FS.Stats as Node.FS.Stats
import Options.Applicative as Options.Applicative
import Protolude.Node as Protolude.Node
import Routing.Duplex as Routing.Duplex
import Routing.Duplex.Parser as Routing.Duplex
import NextjsApp.RouteDuplexCodec as NextjsApp.RouteDuplexCodec

data StaticOrDynamicPageData input
  = StaticPageData input
  | DynamicPageData { input :: input, encoder :: input -> ArgonautCore.Json }

renderPage ::
  forall c input.
  { config :: NextjsApp.Server.Config.Config
  , buildManifest :: NextjsApp.Manifest.ServerBuildManifest.BuildManifest
  , route :: NextjsApp.Route.Route
  , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
  , pageManifest :: NextjsApp.Manifest.PageManifest.PageManifest
  } ->
  Nextjs.Page.PageSpec input ->
  Hyper.Middleware
    Aff
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) c)
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) c)
    Unit
renderPage { config
, buildManifest
, route
, clientPagesManifest
, pageManifest
} page = IndexedMonad.do
  (response :: Either Nextjs.Api.ApiError (StaticOrDynamicPageData input)) <- case page.pageData of
    (Nextjs.Page.DynamicPageData pageData) ->
      Hyper.lift' do
        (response :: Either Affjax.Error (Affjax.Response ArgonautCore.Json)) <- pageData.request
        let
          (decodedResponse :: Either Nextjs.Api.ApiError input) = Nextjs.Api.tryDecodeResponse pageData.codec.decoder response -- yes, we decode and then again encode
        pure $ map (\input -> DynamicPageData { input, encoder: pageData.codec.encoder }) decodedResponse
    (Nextjs.Page.StaticPageData pageData) -> pure $ Right $ StaticPageData pageData
  case response of
    Left (Nextjs.Api.ApiAffjaxError error) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond
        $ Yarn.unlines
            [ "Cannot reach api:"
            , "  " <> Affjax.printError error
            ]
    Left (Nextjs.Api.ApiJsonDecodeError error json) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond
        $ Yarn.unlines
            [ "Cannot decode response:"
            , "  error = " <> ArgonautCodecs.printJsonDecodeError error
            , "  json = " <> ArgonautCore.stringify json
            ]
    Right pageData -> IndexedMonad.do
      let
        routerInput :: input -> NextjsApp.Router.ServerState
        routerInput input =
          { currentPageInfo: Just { route, pageSpecWithInputBoxed: Nextjs.Page.mkPageSpecWithInputBoxed { input, component: page.component, title: page.title } }
          }

        component :: String
        component = case pageData of
          StaticPageData input -> Nextjs.RenderComponent.renderComponent NextjsApp.Router.serverComponent (routerInput input)
          DynamicPageData { input } -> Nextjs.RenderComponent.renderComponent NextjsApp.Router.serverComponent (routerInput input)

        pageData' :: NextjsApp.Server.PageTemplate.StaticOrDynamicPageData
        pageData' = case pageData of
          StaticPageData _ -> NextjsApp.Server.PageTemplate.StaticPageData
          DynamicPageData { input, encoder } -> NextjsApp.Server.PageTemplate.DynamicPageData (encoder input)

        pageRendered :: String
        pageRendered =
          NextjsApp.Server.PageTemplate.pageTemplate
            { faviconsHtml: buildManifest.faviconsHtml
            , clientPagesManifest
            , currentPageManifest: pageManifest
            , pageSpecResolved:
              { title: page.title
              , component
              , pageData: pageData'
              , livereloadPort: config.livereloadPort
              }
            }
      Hyper.writeStatus Hyper.statusOK
      Hyper.closeHeaders
      Hyper.respond pageRendered

app ::
  ∀ c.
  { buildManifest :: NextjsApp.Manifest.ServerBuildManifest.BuildManifest
  , config :: NextjsApp.Server.Config.Config
  } ->
  Hyper.Middleware
    Aff
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) c)
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) c)
    Unit
app { buildManifest, config } = IndexedMonad.do
  request <- Hyper.getRequestData
  case Routing.Duplex.parse NextjsApp.RouteDuplexCodec.routeCodec request.url of
    Left (error :: Routing.Duplex.RouteError) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond $ "Cannot find route: " <> show error
    Right route -> IndexedMonad.do
      Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightYellow) $ "  Page requested: " <> show route
      let
        pageManifest = NextjsApp.Route.lookupFromRouteIdMapping route buildManifest.pages
      let
        mergedPageManifest = NextjsApp.Manifest.PageManifest.mergePageManifests buildManifest.main pageManifest
      Nextjs.Page.unPage
        ( renderPage
            { config
            , buildManifest
            , route
            , clientPagesManifest: buildManifest.pages
            , pageManifest: mergedPageManifest
            }
        )
        (NextjsApp.Route.lookupFromRouteIdMapping route NextjsApp.RouteToPageNonClient.routeIdMapping)

main :: Effect Unit
main =
  launchAff_ do
    config <- liftEffect $ Options.Applicative.execParser NextjsApp.Server.Config.opts
    buildManifest <- liftEffect $ NextjsApp.Manifest.ServerBuildManifest.getBuildManifest config
    let
      (rootPath' :: String) = printPathPosixSandboxAny config.rootPath
    Protolude.Node.filePathExistsAndIs Node.FS.Stats.isDirectory rootPath'
      >>= if _ then
          Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using static files dir: " <> rootPath'
        else
          Protolude.Node.exitWith 1 $ "Could not find static files dir: " <> rootPath'
    liftEffect
      $ Hyper.Node.runServer
          (Hyper.Node.defaultOptionsWithLogging { port = Hyper.Node.Port config.port })
          {}
          (app { buildManifest, config } # Hyper.Node.fileServer rootPath')

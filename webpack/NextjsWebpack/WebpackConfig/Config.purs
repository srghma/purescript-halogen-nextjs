module NextjsWebpack.WebpackConfig.Config where

import ContribWebpackPlugins
import Control.Promise
import Effect.Uncurried
import Pathy
import PathyExtra
import Protolude
import Webpack.Plugins
import Webpack.Types

import Data.Argonaut.Core (Json)
import Data.Array as Array
import Data.Codec.Argonaut (JsonCodec, JsonDecodeError(..))
import Data.Codec.Argonaut as Codec.Argonaut
import Data.Codec.Argonaut.Common as Codec.Argonaut
import Data.Lens as Lens
import Data.Lens.Iso as Lens
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Foreign (Foreign)
import Foreign as Foreign
import Foreign.NullOrUndefined as Foreign.NullOrUndefined
import Foreign.Object (Object)
import Foreign.Object as Object
import NextjsApp.Route (RouteIdMapping, RouteIdMappingRow, Route)
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.Template as NextjsApp.Template
import NextjsWebpack.BuildManifestPlugin as NextjsWebpack.BuildManifestPlugin
import NextjsWebpack.GetClientPagesEntrypoints (ClientPagesLoaderOptions)
import NextjsWebpack.IsomorphicClientPagesLoader as NextjsWebpack.IsomorphicClientPagesLoader
import NextjsWebpack.WebpackConfig.Rules as NextjsWebpack.WebpackConfig.Rules
import NextjsWebpack.WebpackConfig.SplitChunksConfig as NextjsWebpack.WebpackConfig.SplitChunksConfig
import Node.URL as Node.URL
import Record as Record
import Unsafe.Coerce (unsafeCoerce)

-- https://github.com/zeit/next.js/blob/450d4bd0f32a042fd452c81bc3850ec31306eab3/packages/next/next-server/lib/constants.ts#L35

data Target
  = Target__Browser { entrypointsObject :: RouteIdMapping ClientPagesLoaderOptions }
  | Target__Server
  | Target__Mobile { entrypointsObject :: RouteIdMapping ClientPagesLoaderOptions }

-- | Should be one level
toQuery :: Json -> Node.URL.Query
toQuery = unsafeCoerce

config
  :: { target :: Target
     , watch :: Boolean
     , production :: Boolean
     , root :: Path Abs Dir
     , bundleAnalyze :: Boolean
     , spagoOutput :: Path Abs Dir
     }
  -> Configuration
config { target, watch, production, root, bundleAnalyze, spagoOutput } =
  let (entry :: Object (Array String)) =
        case target of
            Target__Server -> Object.fromHomogeneous
                { main: Array.singleton $ printPathPosixSandboxAny $ root </> dir (SProxy :: SProxy "app") </> file (SProxy :: SProxy "server.entry.js")
                }

            Target__Browser { entrypointsObject } ->
                let
                  (pages :: RouteIdMapping (Array String)) =
                    flip NextjsApp.Route.mapRouteIdMappingWithKey entrypointsObject \routeId clientPagesLoaderOptions ->
                      let
                        (route :: Route) = Lens.review NextjsApp.Route._routeToRouteIdIso routeId

                        options =
                          { absoluteCompiledPagePursPath: clientPagesLoaderOptions.absoluteCompiledPagePursPath
                          , absoluteJsDepsPath: clientPagesLoaderOptions.absoluteJsDepsPath
                          , route
                          }
                      in Array.singleton $ "isomorphic-client-pages-loader?" <> Node.URL.toQueryString (toQuery $ spy "asdf" $ Codec.Argonaut.encode NextjsWebpack.IsomorphicClientPagesLoader.optionsCodec options) <> "!"

                  mainPage =
                    { main: Array.singleton $ printPathPosixSandboxAny $ root </> dir (SProxy :: SProxy "app") </> file (SProxy :: SProxy "client.entry.js")
                    }
                 in Object.fromHomogeneous $ Record.union pages mainPage
            Target__Mobile { entrypointsObject } ->
              let
                (absoluteJsDepsPaths :: Array (Path Abs File)) = Array.catMaybes $ map _.absoluteJsDepsPath $ Object.values $ Object.fromHomogeneous entrypointsObject

                mainPath = root </> dir (SProxy :: SProxy "app") </> file (SProxy :: SProxy "mobile.entry.js")

               in Object.fromHomogeneous { main: map printPathPosixSandboxAny $ absoluteJsDepsPaths <> [ mainPath ] }

   in
    { watch
    , target:
        case target of
            Target__Browser _ -> "web"
            Target__Server -> "node"
            Target__Mobile _ -> "web"
    , mode: if production then "production" else "development"
    -- mode: "development"
    , devServer:
        case target of
             Target__Browser _ -> Foreign.NullOrUndefined.undefined
             Target__Server -> Foreign.NullOrUndefined.undefined
             Target__Mobile _ -> Foreign.unsafeToForeign
               { hot: false
               }
    , output:
      { path:
          let outputDir = if production then dir (SProxy :: SProxy ".dist") else dir (SProxy :: SProxy ".dist-dev")
          in printPathPosixSandboxAny $
            case target of
                 Target__Browser _ -> root </> outputDir </> dir (SProxy :: SProxy "client")
                 Target__Server -> root </> outputDir </> dir (SProxy :: SProxy "server")
                 Target__Mobile _ -> root </> dir (SProxy :: SProxy "www")

      , filename: case target of
          Target__Browser _ -> if production then "[name]-[contenthash].js" else "[name].js"
          Target__Server -> "[name].js"
          Target__Mobile _ -> "index.js"

      , publicPath: case target of
          Target__Browser _ -> "/"
          Target__Server -> "/"
          Target__Mobile _ -> "./" -- from https://github.com/jantimon/html-webpack-plugin/issues/488

      , libraryTarget: case target of
          Target__Server -> "commonjs2"
          Target__Browser _ -> "var"
          Target__Mobile _ -> "var"

      -- This saves chunks with the name given via `import()`
      , chunkFilename: case target of
          Target__Browser _ -> Nullable.notNull $ "chunks/" <> if production then "[name]-[contenthash]" else "[name]" <> ".js"
          Target__Server -> Nullable.null
          Target__Mobile _ -> Nullable.null
      }
    , entry: entry

    , node: case target of
        Target__Server -> Foreign.unsafeToForeign
          { __dirname: false -- possible values: false - runtime, true - during complilation, "mock" - "/"
          }
        _ -> Foreign.unsafeToForeign false

    , bail: true
    , profile: false
    , stats: "errors-only"
    , context: printPathPosixSandboxAny root
    , devtool: case target of
        Target__Server -> Foreign.unsafeToForeign false
        _ -> if production then Foreign.unsafeToForeign false else Foreign.unsafeToForeign "eval"

    , "module": { rules: NextjsWebpack.WebpackConfig.Rules.rules { spagoAbsoluteOutputDir: printPathPosixSandboxAny spagoOutput, production } }

    , resolve:
      { extensions: [ ".purs", ".js"]
      }

    , resolveLoader:
      { alias: Object.fromHomogeneous
          { "isomorphic-client-pages-loader":
            case target of
                 -- | Target__Browser _ -> Foreign.unsafeToForeign $ printPathPosixSandboxAny $ root </> dir (SProxy :: SProxy "webpack") </> file (SProxy :: SProxy "isomorphic-client-pages-loader.js")
                 Target__Browser _ -> Foreign.unsafeToForeign $ printPathPosixSandboxAny $ spagoOutput </> dir (SProxy :: SProxy "NextjsWebpack.IsomorphicClientPagesLoader") </> file (SProxy :: SProxy "index.js")
                 _ -> Foreign.unsafeToForeign false
          }
      }
    -- TODO: per page https://github.com/webpack-contrib/mini-css-extract-plugin#extracting-css-based-on-entry
    , plugins: Array.catMaybes
      [ Just $ _MiniCssExtractPlugin
        { filename:
          case target of
              Target__Browser _ -> if production then "css/[name].[hash].css" else "css/[name].css"
              Target__Server -> if production then "css/[name].[hash].css" else "css/[name].css"
              Target__Mobile _ -> "index.css"

        , chunkFilename:
          case target of
              Target__Browser _ -> if production then "css/[id].[hash].css" else "css/[id].css"
              Target__Server -> if production then "css/[id].[hash].css" else "css/[id].css"
              Target__Mobile _ -> "index.css"
        }
      , Just $ webpack._DefinePlugin $
          case target of
                Target__Server -> Foreign.unsafeToForeign
                    -- for purescript-ace on node environment: dont throw "undefined" exception, just make `var ace = false`
                    { "ace": false
                    }
                _ -> Foreign.unsafeToForeign {}

      , case target of
              Target__Server -> Just $ webpack._ProvidePlugin
                  -- on node - use "xhr2" package
                  { "XMLHttpRequest": "xhr2"
                  }
              _ -> Nothing
      , Just $ webpack._NoEmitOnErrorsPlugin
      , Just $ _CleanWebpackPlugin
      , if bundleAnalyze
          then Just $ _BundleAnalyzerPlugin { analyzerPort: 8888 }
          else Nothing

      , case target of
            Target__Browser _ -> Just $ NextjsWebpack.BuildManifestPlugin.buildManifestPlugin
            _ -> Nothing

      , case target of
            Target__Mobile _ -> Just $ _HtmlWebpackPlugin
                { minify: false
                , inject: false -- dont inject headTags and bodyTags after template is generated - we will do that ourselves
                , templateContent: \options -> NextjsApp.Template.template
                  { title: "Purescript Nextjs"
                  , targetData: NextjsApp.Template.TargetData__Mobile
                  , headTags: htmlWebpackPlugin__tags__toString options.htmlWebpackPlugin.tags.headTags
                  , bodyTags: htmlWebpackPlugin__tags__toString options.htmlWebpackPlugin.tags.bodyTags
                  }
                }
            _ -> Nothing

      -- from https://medium.com/@glennreyes/how-to-disable-code-splitting-in-webpack-1c0b1754a3c5
      -- disables chunks completely for mobile , disables lazy loaded files `import("./file.js")`
      , case target of
            Target__Mobile _ -> Just $ webpack.optimize._LimitChunkCountPlugin { maxChunks: 1 }
            _ -> Nothing
      ]
    , optimization:
      { noEmitOnErrors: true

      , splitChunks:
        case target of
             Target__Browser { entrypointsObject } -> Foreign.unsafeToForeign $
               NextjsWebpack.WebpackConfig.SplitChunksConfig.splitChunksConfig
               { totalPages: Array.length $ Object.keys $ Object.fromHomogeneous entrypointsObject
               }
             _ -> Foreign.unsafeToForeign false

      , nodeEnv: false

      , runtimeChunk:
        case target of
            -- extract webpack runtime to separate module, e.g. "/runtime/webpack-xxxxx.js"
            Target__Browser _ -> Foreign.unsafeToForeign { name: "webpack" }
            _ -> Foreign.unsafeToForeign false

      , minimize:
        case target of
             Target__Browser _ -> production
             _ -> false

      -- | minimizer: production && target === "browser" ? [
      -- |   new (require("terser-webpack-plugin"))({}),
      -- |   new (require("optimize-css-assets-webpack-plugin"))({}),

      -- |   // // Minify CSS
      -- |   // new CssMinimizerPlugin({
      -- |   //   postcssOptions: {
      -- |   //     map: {
      -- |   //       // `inline: false` generates the source map in a separate file.
      -- |   //       // Otherwise, the CSS file is needlessly large.
      -- |   //       inline: false,
      -- |   //       // `annotation: false` skips appending the `sourceMappingURL`
      -- |   //       // to the end of the CSS file. Webpack already handles this.
      -- |   //       annotation: false,
      -- |   //     },
      -- |   //   },
      -- |   // }),
      }
    }

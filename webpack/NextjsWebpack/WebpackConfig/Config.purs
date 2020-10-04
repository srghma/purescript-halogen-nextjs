module NextjsWebpack.WebpackConfig.Config where

import Control.Promise
import Effect.Uncurried
import Pathy
import Protolude
import Webpack.Types
import Webpack.Plugins
import ContribWebpackPlugins

import Data.Array as Array
import Data.Nullable (Nullable, notNull)
import Data.Nullable as Nullable
import Foreign (Foreign, unsafeToForeign)
import Foreign as Foreign
import Foreign.Object as Object
import NextjsApp.Route (PagesRec, PagesRecRow, Route)
import NextjsApp.Template as NextjsApp.Template
import NextjsWebpack.BuildManifestPlugin as NextjsWebpack.BuildManifestPlugin
import NextjsWebpack.GetClientPagesEntrypoints (ClientPagesLoaderOptions)
import NextjsWebpack.WebpackConfig.SplitChunksConfig as NextjsWebpack.WebpackConfig.SplitChunksConfig

-- https://github.com/zeit/next.js/blob/450d4bd0f32a042fd452c81bc3850ec31306eab3/packages/next/next-server/lib/constants.ts#L35


client_static_files_runtime_webpack = "webpack"

data Target
  = Target__Browser
  | Target__Server
  | Target__Mobile

config
  :: forall configProps
   . { target :: Target
     , watch :: Boolean
     , production :: Boolean
     , root :: Path Abs Dir
     , pagesPath :: Path Abs Dir
     , bundleAnalyze :: Boolean
     , spagoOutput :: Path Abs Dir
     }
  -> Effect _
config { target, watch, production, root, pagesPath, bundleAnalyze } = do
  -- target !== "server" ? await createClientPagesEntrypoints(pagesPath) : null
  let (entrypointsObject :: PagesRec ClientPagesLoaderOptions) = undefined

  entry <-
    case target of
         -- R.mapObjIndexed((val, key) => `isomorphic-client-pages-loader?${querystring.stringify({ ...val, pageName: key })}!`, entrypointsObject)
         -- | let isomorphicEntrypointsObject = undefined

         -- R.mergeAll([isomorphicEntrypointsObject, { main: path.resolve(root, "app", "client.entry.js") }])

        Target__Browser -> pure undefined
        Target__Server -> pure { main: root </> dir (SProxy :: SProxy "app") </> file (SProxy :: SProxy "server.entry.js") }
        Target__Mobile -> pure undefined
          -- | let absoluteJsDepsPaths = R.pipe(
          -- |   R.values,
          -- |   R.map(R.prop("absoluteJsDepsPath")),
          -- |   RA.compact
          -- | )(entrypointsObject)

          -- | let mainPath = path.resolve(root, "app", "mobile.entry.js")

          -- | let mainPathWithJsDeps = [...absoluteJsDepsPaths, mainPath]

          -- | return { main: mainPathWithJsDeps }

  pure
    { watch
    , target:
        case target of
            Target__Browser -> "web"
            Target__Mobile -> "web"
            Target__Server -> "node"
    , mode: if production then "production" else "development"
    -- mode: "development"
    , devServer:
        case target of
          Target__Browser -> Nullable.null
          Target__Server -> Nullable.null
          Target__Mobile -> Nullable.notNull
            { hot: false
            }
    , output:
      { path:
          let outputDir = if production then dir (SProxy :: SProxy ".dist") else dir (SProxy :: SProxy ".dist-dev")
          in case target of
                  Target__Browser -> root </> outputDir </> dir (SProxy :: SProxy "client")
                  Target__Server -> root </> outputDir </> dir (SProxy :: SProxy "server")
                  Target__Mobile -> root </> dir (SProxy :: SProxy "www")

      , filename: case target of
          Target__Browser -> if production then "[name]-[contenthash].js" else "[name].js"
          Target__Server -> "[name].js"
          Target__Mobile -> "index.js"

      , publicPath: case target of
          Target__Browser -> "/"
          Target__Server -> "/"
          Target__Mobile -> "./" -- from https://github.com/jantimon/html-webpack-plugin/issues/488

      , libraryTarget: case target of
          Target__Server -> "commonjs2"
          Target__Browser -> "var"
          Target__Mobile -> "var"

      -- This saves chunks with the name given via `import()`
      , chunkFilename: case target of
          Target__Browser -> Nullable.notNull $ "chunks/" <> if production then "[name]-[contenthash]" else "[name]" <> ".js"
          Target__Server -> Nullable.null
          Target__Mobile -> Nullable.null
      }
    , entry

    , node: case target of
        Target__Server -> unsafeToForeign
          { __dirname: false -- possible values: false - runtime, true - during complilation, "mock" - "/"
          }
        _ -> unsafeToForeign false

    , bail: true
    , profile: false
    , stats: "errors-only"
    , context: root
    , devtool: case target of
        Target__Server -> unsafeToForeign false
        _ -> if production then unsafeToForeign false else unsafeToForeign "eval"

    , "module": undefined -- { rules: require("./rules")({ target, production }) }
    , resolve:
      { modules: [ "node_modules" ]
      , extensions: [ ".purs", ".js"]
      }

    , resolveLoader:
      { modules: [ "node_modules" ]
      , alias:
          { "isomorphic-client-pages-loader":
            case target of
                 Target__Browser -> unsafeToForeign $ root </> dir (SProxy :: SProxy "webpack") </> file (SProxy :: SProxy "isomorphic-client-pages-loader.js")
                 _ -> unsafeToForeign false
          }
      }
    -- TODO: per page https://github.com/webpack-contrib/mini-css-extract-plugin#extracting-css-based-on-entry
    , plugins: Array.catMaybes
      [ Just $ _MiniCssExtractPlugin
        { filename:
          case target of
              Target__Browser -> if production then "css/[name].[hash].css" else "css/[name].css"
              Target__Server -> if production then "css/[name].[hash].css" else "css/[name].css"
              Target__Mobile -> "index.css"

        , chunkFilename:
          case target of
              Target__Browser -> if production then "css/[id].[hash].css" else "css/[id].css"
              Target__Server -> if production then "css/[id].[hash].css" else "css/[id].css"
              Target__Mobile -> "index.css"
        }
      , Just $ webpack._DefinePlugin $
          case target of
                Target__Server -> Nullable.notNull
                    -- for purescript-ace on node environment: dont throw "undefined" exception, just make `var ace = false`
                    { "ace": false
                    }
                _ -> Nullable.null

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
            Target__Browser -> Just $ NextjsWebpack.BuildManifestPlugin.buildManifestPlugin
            _ -> Nothing

      , case target of
            Target__Mobile -> Just $ _HtmlWebpackPlugin
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
            Target__Mobile -> Just $ webpack.optimize._LimitChunkCountPlugin { maxChunks: 1 }
            _ -> Nothing
      ]
    , optimization:
      { noEmitOnErrors: true

      , splitChunks: case target of
             Target__Browser -> unsafeToForeign $
               NextjsWebpack.WebpackConfig.SplitChunksConfig.splitChunksConfig
               { totalPages: Array.length $ Object.keys $ Object.fromHomogeneous entrypointsObject
               }
             _ -> unsafeToForeign false

      , nodeEnv: false

      , runtimeChunk:
        case target of
            -- extract webpack runtime to separate module, e.g. "/runtime/webpack-xxxxx.js"
            Target__Browser -> unsafeToForeign { name: client_static_files_runtime_webpack }
            _ -> unsafeToForeign false

      , minimize:
        case target of
             Target__Browser -> production
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

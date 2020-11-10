module NextjsWebpack.Entries.Build where

import Pathy (dir, file, (</>))
import PathyExtra (cwd, printPathPosixSandboxAny)
import Protolude
import Ansi.Codes as Ansi
import Ansi.Output as Ansi
import Data.Array.NonEmpty (NonEmptyArray)
import Data.String.NonEmpty (NonEmptyString)
import Effect.Class.Console as Console
import Favicons as Favicons
import NextjsWebpack.FaviconsConfig as NextjsWebpack.FaviconsConfig
import NextjsWebpack.GetClientPagesEntrypoints as NextjsWebpack.GetClientPagesEntrypoints
import NextjsWebpack.WebpackConfig.Config as NextjsWebpack.WebpackConfig.Config
import NextjsWebpack.WebpackConfig.Types
import Node.Buffer (Buffer)
import Node.FS.Aff as Node.FS.Aff
import Unsafe.Coerce (unsafeCoerce)
import Webpack.Compiler as Webpack.Compiler
import Webpack.GetError as Webpack.GetError

main :: Effect Unit
main =
  launchAff_ do
    root <- liftEffect cwd
    let
      apiUrl = "http://localhost:5000/graphql"

      production = true

      spagoOutput = root </> dir (SProxy :: SProxy "output")

      pagesModuleNamePrefix :: NonEmptyArray NonEmptyString
      pagesModuleNamePrefix = unsafeCoerce [ "NextjsApp", "Pages" ]

      appDir = root </> dir (SProxy :: SProxy "app")
    (faviconFileBuffer :: Buffer) <- Node.FS.Aff.readFile (printPathPosixSandboxAny (root </> file (SProxy :: SProxy "purescript-favicon-black.svg")))
    (favIconResponse :: Favicons.FavIconResponse) <- Favicons.favicons faviconFileBuffer (NextjsWebpack.FaviconsConfig.faviconsConfig production)
    entrypointsObject <- NextjsWebpack.GetClientPagesEntrypoints.getClientPagesEntrypoints { pagesModuleNamePrefix, appDir, spagoAbsoluteOutputDir: spagoOutput }
    let
      browserConfig =
        NextjsWebpack.WebpackConfig.Config.config
          { target: Target__Browser { entrypointsObject, favIconResponse: Just favIconResponse }
          , watch: false
          , production
          , root
          , bundleAnalyze: false
          , spagoOutput
          , apiUrl
          }
    let
      serverConfig =
        NextjsWebpack.WebpackConfig.Config.config
          { target: Target__Server
          , watch: false
          , production
          , root
          , bundleAnalyze: false
          , spagoOutput
          , apiUrl
          }
    liftEffect
      $ Webpack.Compiler.webpackCompilerRunMulti (Webpack.Compiler.webpackCompilerMulti [ browserConfig, serverConfig ]) \merror stats -> case Webpack.GetError.webpackGetErrors merror stats of
          Just errors -> throwError $ unsafeCoerce $ errors
          Nothing -> do
            Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Compiled"

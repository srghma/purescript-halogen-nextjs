module NextjsWebpack.Entries.Build where

import Pathy
import PathyExtra
import Protolude
import Webpack.Types

import Affjax as Affjax
import Ansi.Codes as Ansi
import Ansi.Output as Ansi
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.String.Yarn as Yarn
import Effect.Class.Console as Console
import NextjsWebpack.WebpackConfig.Config as NextjsWebpack.WebpackConfig.Config
import Node.Process as Node.Process
import Options.Applicative as Options.Applicative
import Protolude.Node as Protolude.Node
import Unsafe.Coerce (unsafeCoerce)
import Webpack.Compiler as Webpack.Compiler
import Webpack.GetError as Webpack.GetError
import NextjsWebpack.GetClientPagesEntrypoints as NextjsWebpack.GetClientPagesEntrypoints
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString


main :: Effect Unit
main = launchAff_ do
  root <- liftEffect cwd

  let spagoOutput = root </> dir (SProxy :: SProxy "output")

  let
    pagesModuleNamePrefix :: NonEmptyArray NonEmptyString
    pagesModuleNamePrefix = unsafeCoerce ["NextjsApp", "Pages"]

    appDir = root </> dir (SProxy :: SProxy "app")

  entrypointsObject <- NextjsWebpack.GetClientPagesEntrypoints.getClientPagesEntrypoints { pagesModuleNamePrefix, appDir, spagoAbsoluteOutputDir: spagoOutput }

  let configs =
        map NextjsWebpack.WebpackConfig.Config.config
        [ { target: NextjsWebpack.WebpackConfig.Config.Target__Browser { entrypointsObject }
          , watch: false
          , production: false
          , root
          , bundleAnalyze: false
          , spagoOutput
          }
        , { target: NextjsWebpack.WebpackConfig.Config.Target__Server
          , watch: false
          , production: false
          , root
          , bundleAnalyze: false
          , spagoOutput
          }
        ]

  liftEffect $ Webpack.Compiler.webpackCompilerRunMulti (Webpack.Compiler.webpackCompilerMulti configs) \merror stats ->
    case Webpack.GetError.webpackGetErrors merror stats of
         Just errors -> throwError $ unsafeCoerce $ errors
         Nothing -> Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Compiled"

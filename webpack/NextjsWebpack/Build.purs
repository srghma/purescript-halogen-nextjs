module NextjsWebpack.Build where

import Protolude

import Affjax as Affjax
import Ansi.Codes as Ansi
import Ansi.Output as Ansi
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.String.Yarn as Yarn
import Effect.Class.Console as Console
import Options.Applicative as Options.Applicative
import Protolude.Node as Protolude.Node
import Node.Process as Node.Process
import Pathy
import PathyExtra

main :: Effect Unit
main = do
  entrypointsObject <- undefined
  root <- cwd
  Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using static files dir: "

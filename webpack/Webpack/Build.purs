module Webpack.Build where

import Protolude

import Affjax as Affjax
import Ansi.Codes (Color(..)) as Ansi
import Ansi.Output (foreground, withGraphics) as Ansi
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode (printJsonDecodeError) as ArgonautCodecs
import Data.String.Yarn as Yarn
import Effect.Class.Console as Console
import Options.Applicative as Options.Applicative
import Protolude.Node as Protolude.Node

main :: Effect Unit
main = do
  Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using static files dir: "

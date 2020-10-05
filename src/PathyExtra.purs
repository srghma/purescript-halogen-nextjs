module PathyExtra where

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
import Node.Process as Node.Process
import Pathy

cwd :: Effect (Path Abs Dir)
cwd = Node.Process.cwd >>= \(d :: String) ->
  case parseAbsDir posixParser d of
       Just d' -> pure d'
       Nothing -> throwError $ error $ d <> "is cwd, but not absolute"

printPathPosixSandboxAny = printPath posixPrinter <<< sandboxAny

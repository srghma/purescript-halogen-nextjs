module PathyExtra where

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
import Data.String as String

mkDirAbsoluteIfNotAlready :: String -> String
mkDirAbsoluteIfNotAlready string =
  case String.stripSuffix (String.Pattern "/") string of
       Just _ -> string
       Nothing -> string <> "/"

cwd :: Effect (Path Abs Dir)
cwd = Node.Process.cwd >>= \(d :: String) ->
  let validD = mkDirAbsoluteIfNotAlready d
  in case parseAbsDir posixParser validD of
       Just d' -> pure d'
       Nothing -> throwError $ error $ validD <> "is cwd, but not absolute"

printPathPosixSandboxAny :: ∀ a b. IsRelOrAbs a ⇒ IsDirOrFile b ⇒ Path a b → String
printPathPosixSandboxAny = printPath posixPrinter <<< sandboxAny

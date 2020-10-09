module PathyExtra where

import Protolude

import Node.Process as Node.Process
import Pathy (class IsDirOrFile, class IsRelOrAbs, Abs, Dir, Path, parseAbsDir, posixParser, posixPrinter, printPath, sandboxAny)
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

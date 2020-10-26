module PathyOptparse where

import Protolude
import Pathy
import Pathy as Pathy
import Data.Maybe as Maybe
import Effect.Exception
import Options.Applicative

createPosixParser parse name =
  eitherReader
    $ \s -> case parse posixParser s of
        Nothing -> Left $ "Can't parse as " <> name <> ": `" <> show s <> "`"
        Just a -> Right a

absDirPosixParser :: ReadM (Path Abs Dir)
absDirPosixParser = createPosixParser parseAbsDir "posix abs dir"

absFilePosixParser :: ReadM (Path Abs File)
absFilePosixParser = createPosixParser parseAbsFile "posix abs file"

module NodeReadEnv where

import Protolude

import Control.Monad.Reader.Trans (ReaderT, ask)
import Control.Monad.Except (Except)
import Control.Monad.Except.Trans (class MonadThrow, throwError)
import Foreign.Object (Object)
import Data.Int as Int
import Global (isFinite, isNaN, readFloat)
import Data.String (toLower)

data ParseError
  = ReadEnvError__MissingVariable
  | ReadEnvError__Invalid String

type ReadM a = ReaderT String (Except ParseError) a

readerAbort :: forall a. ParseError -> ReadM a
readerAbort = throwError

readerError :: forall a. String -> ReadM a
readerError = readerAbort <<< ReadEnvError__Invalid

eitherReader :: forall a. (String -> Either String a) -> ReadM a
eitherReader f = ask >>= either readerError pure <<< f

str :: ReadM String
str = ask

int :: ReadM Int
int = eitherReader $ \s -> case Int.fromString s of
  Nothing -> Left $ "Can't parse as Int: `" <> show s <> "`"
  Just a -> Right a

-- | Number 'Option' reader.
number :: ReadM Number
number = eitherReader $ \s -> let n = readFloat s in if isNaN n || not isFinite n
  then Left $ "Can't parse as Number: `" <> show s <> "`"
  else Right n

-- | Boolean 'Option' reader.
boolean :: ReadM Boolean
boolean = eitherReader $ toLower >>> case _ of
  "true" -> Right true
  "false" -> Right false
  "1" -> Right true
  "0" -> Right false
  s -> Left $ "Can't parse as Boolean: `" <> show s <> "`"

option :: forall a. ReadM a -> String -> Parser a
option r m = mkParser d g rdr
  where
    Mod f d g = metavar "ARG" `append` m
    (OptionFields fields) = f (OptionFields {optNames: [], optCompleter: mempty, optNoArgError: ExpectsArgError})
    crdr = CReader {crCompleter: fields.optCompleter, crReader: r}
    rdr = OptReader fields.optNames crdr fields.optNoArgError

-- | readConfig :: Object String -> Either String Config
-- | readConfig env = { greeting: _, count: _ }
-- |   <$> value "GREETING"
-- |   <*> (value "COUNT" >>= Int.fromString >>> note "Invalid COUNT")
-- |   where
-- |     value name =
-- |       note ("Missing variable " <> name) $ lookup name env

module NextjsApp.Data.NonUsedEmail where

import Protolude

import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Regex
import Data.String.Regex.Unsafe as Regex
import NextjsApp.Queries.Utils (graphqlApiQueryRequestOrThrow)
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsApp.Queries.IsUsernameOrEmailInUse

data NonUsedEmail__Error
  = NonUsedEmail__Error__Empty
  | NonUsedEmail__Error__BadLength
  | NonUsedEmail__Error__BadFormat
  | NonUsedEmail__Error__InUse

newtype NonUsedEmail = NonUsedEmail NonEmptyString

toString :: NonUsedEmail -> String
toString (NonUsedEmail s) = NonEmptyString.toString s

minEmailLength :: Int
minEmailLength = 1

maxEmailLength :: Int
maxEmailLength = 24

fromString :: String -> Aff (Either NonUsedEmail__Error NonUsedEmail)
fromString = \str -> runExceptT do
  nstr <- NonEmptyString.fromString str # maybe (throwError NonUsedEmail__Error__Empty) pure

  unless (validLength nstr) (throwError NonUsedEmail__Error__BadLength)
  unless (validFormat nstr) (throwError NonUsedEmail__Error__BadFormat)

  unlessM (liftAff $ validNotInUse nstr) (throwError NonUsedEmail__Error__InUse)

  pure $ NonUsedEmail nstr

  where

  validLength :: NonEmptyString -> Boolean
  validLength = NonEmptyString.length >>> \l -> l > minEmailLength && l <= maxEmailLength

  validFormat :: NonEmptyString -> Boolean
  validFormat = NonEmptyString.toString >>> Regex.test r
    where
      r = Regex.unsafeRegex """^[a-zA-Z]([a-zA-Z0-9][_]?)+$""" Regex.noFlags

  validNotInUse :: NonEmptyString -> Aff Boolean
  validNotInUse nstr = isUsernameOrEmailInUse nstr <#> not

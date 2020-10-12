module NextjsApp.Data.Password where

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString

newtype Password = Password NonEmptyString

minPasswordLength :: Int
minPasswordLength = 8

maxPasswordLength :: Int
maxPasswordLength = 200

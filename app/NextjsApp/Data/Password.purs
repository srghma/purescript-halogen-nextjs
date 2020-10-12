module NextjsApp.Data.Password where

import Protolude

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Unsafe.Coerce (unsafeCoerce)

newtype Password = Password NonEmptyString

toString :: Password -> String
toString = unsafeCoerce

minPasswordLength :: Int
minPasswordLength = 8

maxPasswordLength :: Int
maxPasswordLength = 200

data PasswordError
  = PasswordError__TooShort
  | PasswordError__TooLong

fromString :: String -> Either PasswordError Password
fromString = NonEmptyString.fromString >>>
  case _ of
      Nothing -> Left $ PasswordError__TooShort
      Just str ->
              let
                l = NonEmptyString.length str
              in case unit of
                _ | l < minPasswordLength -> Left $ PasswordError__TooShort
                  | l > maxPasswordLength -> Left $ PasswordError__TooLong
                  | otherwise -> Right $ Password str

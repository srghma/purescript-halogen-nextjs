module Data.Email where

import Protolude
import Unsafe.Coerce (unsafeCoerce)
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import EmailValidator

newtype Email = Email NonEmptyString

toNonEmptyString :: Email -> NonEmptyString
toNonEmptyString = unsafeCoerce

toString :: Email -> String
toString = unsafeCoerce

fromString :: String -> Maybe Email
fromString = NonEmptyString.fromString >>= \email ->
  if emailValidate (NonEmptyString.toString email)
    then Just email
    else Nothing

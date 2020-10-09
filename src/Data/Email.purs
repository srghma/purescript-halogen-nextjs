module Data.Email where

import Protolude
import Unsafe.Coerce (unsafeCoerce)
import Data.String.NonEmpty (NonEmptyString)

newtype Email = Email NonEmptyString

foreign import emailValidate :: String -> Boolean

toNonEmptyString :: Email -> NonEmptyString
toNonEmptyString = unsafeCoerce

toString :: Email -> String
toString = unsafeCoerce

fromString :: String -> Maybe Email
fromString email =
  if emailValidate email
    then Just $ unsafeCoerce email
    else Nothing

module NextjsApp.Data.NonUsedUsernameOrEmail where

import Protolude

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import NextjsApp.Queries.IsUsernameOrEmailInUse (isUsernameOrEmailInUse)

data NonUsedUsernameOrEmail__Error
  = NonUsedUsernameOrEmail__Error__Empty
  | NonUsedUsernameOrEmail__Error__InUse

newtype NonUsedUsernameOrEmail = NonUsedUsernameOrEmail NonEmptyString

toString :: NonUsedUsernameOrEmail -> String
toString (NonUsedUsernameOrEmail s) = NonEmptyString.toString s

fromString :: String -> Aff (Either NonUsedUsernameOrEmail__Error NonUsedUsernameOrEmail)
fromString = NonEmptyString.fromString >>>
  case _ of
    Nothing -> pure $ Left NonUsedUsernameOrEmail__Error__Empty
    Just usernameOrEmail -> isUsernameOrEmailInUse usernameOrEmail <#>
      if _
        then Left NonUsedUsernameOrEmail__Error__InUse
        else Right (NonUsedUsernameOrEmail usernameOrEmail)

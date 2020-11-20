module NextjsApp.Data.InUseUsernameOrEmail where

import GraphQLClient
import Protolude

import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Queries.Utils
import NextjsApp.Queries.IsUsernameOrEmailInUse

data InUseUsernameOrEmail__Error
  = InUseUsernameOrEmail__Error__Empty
  | InUseUsernameOrEmail__Error__NotInUse

newtype InUseUsernameOrEmail = InUseUsernameOrEmail NonEmptyString

toString (InUseUsernameOrEmail s) = NonEmptyString.toString s

fromString :: String -> Aff (Either InUseUsernameOrEmail__Error InUseUsernameOrEmail)
fromString = NonEmptyString.fromString >>>
  case _ of
    Nothing -> pure $ Left InUseUsernameOrEmail__Error__Empty
    Just usernameOrEmail -> isUsernameOrEmailInUse usernameOrEmail <#>
      if _
        then Right (InUseUsernameOrEmail usernameOrEmail)
        else Left InUseUsernameOrEmail__Error__NotInUse

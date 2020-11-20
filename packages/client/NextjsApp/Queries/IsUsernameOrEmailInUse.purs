module NextjsApp.Queries.IsUsernameOrEmailInUse where

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

data NonUsedUsernameOrEmail__Error
  = NonUsedUsernameOrEmail__Error__Empty
  | NonUsedUsernameOrEmail__Error__InUse

newtype NonUsedUsernameOrEmail = NonUsedUsernameOrEmail NonEmptyString

toString (NonUsedUsernameOrEmail s) = NonEmptyString.toString s

fromString :: String -> Aff (Either NonUsedUsernameOrEmail__Error NonUsedUsernameOrEmail)
fromString = NonEmptyString.fromString >>>
  case _ of
    Nothing -> pure $ Left NonUsedUsernameOrEmail__Error__Empty
    Just usernameOrEmail -> isUsernameOrEmailInUse usernameOrEmail <#>
      if _
        then Left NonUsedUsernameOrEmail__Error__InUse
        else Right (NonUsedUsernameOrEmail usernameOrEmail)

isUsernameOrEmailInUse :: NonEmptyString -> Aff Boolean
isUsernameOrEmailInUse usernameOrEmail = graphqlApiQueryRequestOrThrow $
  NextjsGraphqlApi.Query.userByUsernameOrEmail
    { usernameOrEmail: NonEmptyString.toString usernameOrEmail
    }
    (NextjsGraphqlApi.Object.User.id)
    <#> Maybe.isJust

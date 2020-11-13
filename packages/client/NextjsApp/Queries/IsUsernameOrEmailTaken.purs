module NextjsApp.Queries.IsUsernameOrEmailTaken where

import GraphQLClient
import Protolude

import Api.Object.User as Api.Object.User
import Api.Query as Api.Query
import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv

data NonTakenUsernameOrEmail__Error
  = NonTakenUsernameOrEmail__Error__Empty
  | NonTakenUsernameOrEmail__Error__InUse

newtype NonTakenUsernameOrEmail = NonTakenUsernameOrEmail NonEmptyString

toString (NonTakenUsernameOrEmail s) = NonEmptyString.toString s

fromString :: String -> Aff (Either NonTakenUsernameOrEmail__Error NonTakenUsernameOrEmail)
fromString = NonEmptyString.fromString >>>
  case _ of
    Nothing -> pure $ Left NonTakenUsernameOrEmail__Error__Empty
    Just usernameOrEmail -> isUsernameOrEmailTaken usernameOrEmail <#>
      if _
        then Right (NonTakenUsernameOrEmail usernameOrEmail)
        else Left NonTakenUsernameOrEmail__Error__InUse

isUsernameOrEmailTaken :: NonEmptyString -> Aff Boolean
isUsernameOrEmailTaken usernameOrEmail =
  GraphQLClient.graphqlQueryRequest
  NextjsApp.NodeEnv.env.apiUrl
  GraphQLClient.defaultRequestOptions
  query >>=
    (throwError <<< error <<< GraphQLClient.printGraphQLError) \/ pure
  where
    query :: SelectionSet Scope__RootQuery Boolean
    query = Api.Query.userByUsernameOrEmail { usernameOrEmail: NonEmptyString.toString usernameOrEmail } (pure unit) <#> Maybe.isJust

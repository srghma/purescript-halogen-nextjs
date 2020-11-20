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

isUsernameOrEmailInUse :: NonEmptyString -> Aff Boolean
isUsernameOrEmailInUse usernameOrEmail = graphqlApiQueryRequestOrThrow $
  NextjsGraphqlApi.Query.userByUsernameOrEmail
    { usernameOrEmail: NonEmptyString.toString usernameOrEmail
    }
    (NextjsGraphqlApi.Object.User.id)
    <#> Maybe.isJust

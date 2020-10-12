module NextjsApp.Data.EmailFromString where

import Protolude
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Email (Email)
import Data.Email as Email
import Api.Object.User as Api.Object.User
import Api.Query as Api.Query
import GraphQLClient as GraphQLClient
import NextjsApp.ApiUrl

data EmailError
  = EmailError__Invalid
  | EmailError__InUse Boolean

fromString = Email.fromString >>>
  case _ of
    Nothing -> pure $ Left EmailError__Invalid
    Just email -> liftAff (isEmailTaken email) >>=
      case _ of
           Nothing -> pure $ Right email
           Just isConfirmed -> pure $ Left $ EmailError__InUse isConfirmed

isEmailTaken :: Email -> Aff (Maybe Boolean)
isEmailTaken email = GraphQLClient.graphqlQueryRequest apiUrl GraphQLClient.defaultRequestOptions query >>= (throwError <<< error <<< GraphQLClient.printGraphQLError) \/ pure
  where
    query = Api.Query.userByEmail { email: Email.toString email } (Api.Object.User.isConfirmed)

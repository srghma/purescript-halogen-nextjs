module NextjsApp.Queries.Utils where

import GraphQLClient
import Protolude

import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv

throwEitherGraphqlError = (throwError <<< error <<< GraphQLClient.printGraphQLError) \/ pure

------------

graphqlApiQueryRequest =
  GraphQLClient.graphqlQueryRequest
  NextjsApp.NodeEnv.env.apiUrl
  GraphQLClient.defaultRequestOptions

graphqlApiQueryRequestOrThrow query = graphqlApiQueryRequest query >>= throwEitherGraphqlError

-----------------

graphqlApiMutationRequest =
  GraphQLClient.graphqlMutationRequest
  NextjsApp.NodeEnv.env.apiUrl
  GraphQLClient.defaultRequestOptions

graphqlApiMutationRequestOrThrow query = graphqlApiMutationRequest query >>= throwEitherGraphqlError

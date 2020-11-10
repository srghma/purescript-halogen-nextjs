module Api.Object.UserAuthentication where

import GraphQLClient
  (SelectionSet, selectionForField, graphqlDefaultResponseScalarDecoder)
import Api.Scopes (Scope__UserAuthentication)
import Api.Scalars (Datetime, Uuid, Id)

createdAt :: SelectionSet Scope__UserAuthentication Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

id :: SelectionSet Scope__UserAuthentication Uuid
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

identifier :: SelectionSet Scope__UserAuthentication String
identifier = selectionForField
             "identifier"
             []
             graphqlDefaultResponseScalarDecoder

nodeId :: SelectionSet Scope__UserAuthentication Id
nodeId = selectionForField "nodeId" [] graphqlDefaultResponseScalarDecoder

service :: SelectionSet Scope__UserAuthentication String
service = selectionForField "service" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__UserAuthentication Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

module Api.Object.UserOauth where

import GraphQLClient
  (SelectionSet, selectionForField, graphqlDefaultResponseScalarDecoder)
import Api.Scopes (Scope__UserOauth)
import Api.Scalars (Id, Uuid, Datetime)

id :: SelectionSet Scope__UserOauth Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__UserOauth Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

service :: SelectionSet Scope__UserOauth String
service = selectionForField "service" [] graphqlDefaultResponseScalarDecoder

serviceIdentifier :: SelectionSet Scope__UserOauth String
serviceIdentifier = selectionForField
                    "serviceIdentifier"
                    []
                    graphqlDefaultResponseScalarDecoder

createdAt :: SelectionSet Scope__UserOauth Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__UserOauth Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

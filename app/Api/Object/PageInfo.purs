module Api.Object.PageInfo where

import GraphQLClient
  (SelectionSet, selectionForField, graphqlDefaultResponseScalarDecoder)
import Api.Scopes (Scope__PageInfo)
import Data.Maybe (Maybe)
import Api.Scalars (Cursor)

endCursor :: SelectionSet Scope__PageInfo (Maybe Cursor)
endCursor = selectionForField "endCursor" [] graphqlDefaultResponseScalarDecoder

hasNextPage :: SelectionSet Scope__PageInfo Boolean
hasNextPage = selectionForField
              "hasNextPage"
              []
              graphqlDefaultResponseScalarDecoder

hasPreviousPage :: SelectionSet Scope__PageInfo Boolean
hasPreviousPage = selectionForField
                  "hasPreviousPage"
                  []
                  graphqlDefaultResponseScalarDecoder

startCursor :: SelectionSet Scope__PageInfo (Maybe Cursor)
startCursor = selectionForField
              "startCursor"
              []
              graphqlDefaultResponseScalarDecoder

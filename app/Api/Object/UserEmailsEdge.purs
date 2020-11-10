module Api.Object.UserEmailsEdge where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__UserEmailsEdge, Scope__UserEmail)
import Data.Maybe (Maybe)
import Api.Scalars (Cursor)

cursor :: SelectionSet Scope__UserEmailsEdge (Maybe Cursor)
cursor = selectionForField "cursor" [] graphqlDefaultResponseScalarDecoder

node :: forall r . SelectionSet
                   Scope__UserEmail
                   r -> SelectionSet
                        Scope__UserEmailsEdge
                        r
node = selectionForCompositeField
       "node"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

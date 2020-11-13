module NextjsGraphqlApi.Object.UserEmailsEdge where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__UserEmailsEdge, Scope__UserEmail)
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Cursor)

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

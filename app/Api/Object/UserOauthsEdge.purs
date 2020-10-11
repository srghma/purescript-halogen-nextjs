module Api.Object.UserOauthsEdge where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__UserOauthsEdge, Scope__UserOauth)
import Data.Maybe (Maybe)
import Api.Scalars (Cursor)

cursor :: SelectionSet Scope__UserOauthsEdge (Maybe Cursor)
cursor = selectionForField "cursor" [] graphqlDefaultResponseScalarDecoder

node :: forall r . SelectionSet
                   Scope__UserOauth
                   r -> SelectionSet
                        Scope__UserOauthsEdge
                        (Maybe
                         r)
node = selectionForCompositeField
       "node"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

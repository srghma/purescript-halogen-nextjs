module Api.Object.ResetPasswordPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__ResetPasswordPayload)
import Data.Maybe (Maybe)
import Api.Scalars (Jwt)

clientMutationId :: SelectionSet Scope__ResetPasswordPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

jwt :: SelectionSet Scope__ResetPasswordPayload (Maybe Jwt)
jwt = selectionForField "jwt" [] graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__ResetPasswordPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

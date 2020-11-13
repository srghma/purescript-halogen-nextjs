module Api.Object.WebLoginPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__User, Scope__WebLoginPayload)

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__WebLoginPayload
                        r
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

module Api.Object.UserEmail where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__UserEmail, Scope__User)
import Api.Scalars (Datetime, Id, Uuid)
import Data.Maybe (Maybe)

createdAt :: SelectionSet Scope__UserEmail Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

email :: SelectionSet Scope__UserEmail String
email = selectionForField "email" [] graphqlDefaultResponseScalarDecoder

id :: SelectionSet Scope__UserEmail Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

isVerified :: SelectionSet Scope__UserEmail Boolean
isVerified = selectionForField
             "isVerified"
             []
             graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__UserEmail Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__UserEmail Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__UserEmail
                        (Maybe
                         r)
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userId :: SelectionSet Scope__UserEmail Uuid
userId = selectionForField "userId" [] graphqlDefaultResponseScalarDecoder

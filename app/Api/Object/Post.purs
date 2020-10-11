module Api.Object.Post where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__Post, Scope__User)
import Api.Scalars (Id, Uuid, Datetime)
import Data.Maybe (Maybe)

id :: SelectionSet Scope__Post Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__Post Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

name :: SelectionSet Scope__Post String
name = selectionForField "name" [] graphqlDefaultResponseScalarDecoder

content :: SelectionSet Scope__Post String
content = selectionForField "content" [] graphqlDefaultResponseScalarDecoder

userId :: SelectionSet Scope__Post Uuid
userId = selectionForField "userId" [] graphqlDefaultResponseScalarDecoder

createdAt :: SelectionSet Scope__Post Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__Post Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

userByUserId :: forall r . SelectionSet
                           Scope__User
                           r -> SelectionSet
                                Scope__Post
                                (Maybe
                                 r)
userByUserId = selectionForCompositeField
               "userByUserId"
               []
               graphqlDefaultResponseFunctorOrScalarDecoderTransformer

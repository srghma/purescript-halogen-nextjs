module Api.Object.User where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Optional
  , selectionForCompositeField
  , toGraphQLArguments
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes (Scope__User, Scope__PostsConnection)
import Api.Scalars (Id, Uuid, Datetime, Cursor)
import Data.Maybe (Maybe)
import Api.Enum.PostsOrderBy (PostsOrderBy)
import Api.InputObject as Api.InputObject
import Type.Row (type (+))

id :: SelectionSet Scope__User Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__User Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

firstName :: SelectionSet Scope__User String
firstName = selectionForField "firstName" [] graphqlDefaultResponseScalarDecoder

lastName :: SelectionSet Scope__User String
lastName = selectionForField "lastName" [] graphqlDefaultResponseScalarDecoder

email :: SelectionSet Scope__User String
email = selectionForField "email" [] graphqlDefaultResponseScalarDecoder

avatarUrl :: SelectionSet Scope__User (Maybe String)
avatarUrl = selectionForField "avatarUrl" [] graphqlDefaultResponseScalarDecoder

isConfirmed :: SelectionSet Scope__User Boolean
isConfirmed = selectionForField
              "isConfirmed"
              []
              graphqlDefaultResponseScalarDecoder

createdAt :: SelectionSet Scope__User Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__User Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

type PostsByUserIdInputRowOptional r = ( first :: Optional Int
                                       , last :: Optional Int
                                       , offset :: Optional Int
                                       , before :: Optional Cursor
                                       , after :: Optional Cursor
                                       , orderBy :: Optional
                                                    (Array
                                                     PostsOrderBy)
                                       , condition :: Optional
                                                      Api.InputObject.PostCondition
                                       | r
                                       )

type PostsByUserIdInput = { | PostsByUserIdInputRowOptional + () }

postsByUserId :: forall r . PostsByUserIdInput -> SelectionSet
                                                  Scope__PostsConnection
                                                  r -> SelectionSet
                                                       Scope__User
                                                       r
postsByUserId input = selectionForCompositeField
                      "postsByUserId"
                      (toGraphQLArguments
                       input)
                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer

fullName :: SelectionSet Scope__User (Maybe String)
fullName = selectionForField "fullName" [] graphqlDefaultResponseScalarDecoder

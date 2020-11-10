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
import Api.Scopes
  (Scope__User, Scope__PostsConnection, Scope__UserEmailsConnection)
import Data.Maybe (Maybe)
import Api.Scalars (Datetime, Uuid, Id, Cursor)
import Api.InputObject (PostCondition, UserEmailCondition) as Api.InputObject
import Api.Enum.PostsOrderBy (PostsOrderBy)
import Type.Row (type (+))
import Api.Enum.UserEmailsOrderBy (UserEmailsOrderBy)

avatarUrl :: SelectionSet Scope__User (Maybe String)
avatarUrl = selectionForField "avatarUrl" [] graphqlDefaultResponseScalarDecoder

createdAt :: SelectionSet Scope__User Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

id :: SelectionSet Scope__User Uuid
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

isAdmin :: SelectionSet Scope__User Boolean
isAdmin = selectionForField "isAdmin" [] graphqlDefaultResponseScalarDecoder

name :: SelectionSet Scope__User (Maybe String)
name = selectionForField "name" [] graphqlDefaultResponseScalarDecoder

nodeId :: SelectionSet Scope__User Id
nodeId = selectionForField "nodeId" [] graphqlDefaultResponseScalarDecoder

type PostsInputRowOptional r = ( after :: Optional Cursor
                               , before :: Optional Cursor
                               , condition :: Optional
                                              Api.InputObject.PostCondition
                               , first :: Optional Int
                               , last :: Optional Int
                               , offset :: Optional Int
                               , orderBy :: Optional (Array PostsOrderBy)
                               | r
                               )

type PostsInput = { | PostsInputRowOptional + () }

posts :: forall r . PostsInput -> SelectionSet
                                  Scope__PostsConnection
                                  r -> SelectionSet
                                       Scope__User
                                       r
posts input = selectionForCompositeField
              "posts"
              (toGraphQLArguments
               input)
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

updatedAt :: SelectionSet Scope__User Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

type UserEmailsInputRowOptional r = ( after :: Optional Cursor
                                    , before :: Optional Cursor
                                    , condition :: Optional
                                                   Api.InputObject.UserEmailCondition
                                    , first :: Optional Int
                                    , last :: Optional Int
                                    , offset :: Optional Int
                                    , orderBy :: Optional
                                                 (Array
                                                  UserEmailsOrderBy)
                                    | r
                                    )

type UserEmailsInput = { | UserEmailsInputRowOptional + () }

userEmails :: forall r . UserEmailsInput -> SelectionSet
                                            Scope__UserEmailsConnection
                                            r -> SelectionSet
                                                 Scope__User
                                                 r
userEmails input = selectionForCompositeField
                   "userEmails"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

username :: SelectionSet Scope__User String
username = selectionForField "username" [] graphqlDefaultResponseScalarDecoder

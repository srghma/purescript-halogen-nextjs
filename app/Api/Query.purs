module Api.Query where

import GraphQLClient
  ( SelectionSet
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , toGraphQLArguments
  , Optional
  )
import Api.Scalars (Id, Cursor, Uuid)
import Type.Row (type (+))
import Api.Scopes
  ( Scope__Node
  , Scope__PostsConnection
  , Scope__Post
  , Scope__UserOauth
  , Scope__User
  )
import Data.Maybe (Maybe)
import Api.Enum.PostsOrderBy (PostsOrderBy)
import Api.InputObject as Api.InputObject

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__RootQuery
                         r
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

id :: SelectionSet Scope__RootQuery Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

type NodeInputRowRequired r = ( id :: Id | r )

type NodeInput = { | NodeInputRowRequired + () }

node :: forall r . NodeInput -> SelectionSet
                                Scope__Node
                                r -> SelectionSet
                                     Scope__RootQuery
                                     (Maybe
                                      r)
node input = selectionForCompositeField
             "node"
             (toGraphQLArguments
              input)
             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type AllPostsInputRowOptional r = ( first :: Optional Int
                                  , last :: Optional Int
                                  , offset :: Optional Int
                                  , before :: Optional Cursor
                                  , after :: Optional Cursor
                                  , orderBy :: Optional (Array PostsOrderBy)
                                  , condition :: Optional
                                                 Api.InputObject.PostCondition
                                  | r
                                  )

type AllPostsInput = { | AllPostsInputRowOptional + () }

allPosts :: forall r . AllPostsInput -> SelectionSet
                                        Scope__PostsConnection
                                        r -> SelectionSet
                                             Scope__RootQuery
                                             (Maybe
                                              r)
allPosts input = selectionForCompositeField
                 "allPosts"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type PostByRowIdInputRowRequired r = ( rowId :: Uuid | r )

type PostByRowIdInput = { | PostByRowIdInputRowRequired + () }

postByRowId :: forall r . PostByRowIdInput -> SelectionSet
                                              Scope__Post
                                              r -> SelectionSet
                                                   Scope__RootQuery
                                                   (Maybe
                                                    r)
postByRowId input = selectionForCompositeField
                    "postByRowId"
                    (toGraphQLArguments
                     input)
                    graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserOauthByRowIdInputRowRequired r = ( rowId :: Uuid | r )

type UserOauthByRowIdInput = { | UserOauthByRowIdInputRowRequired + () }

userOauthByRowId :: forall r . UserOauthByRowIdInput -> SelectionSet
                                                        Scope__UserOauth
                                                        r -> SelectionSet
                                                             Scope__RootQuery
                                                             (Maybe
                                                              r)
userOauthByRowId input = selectionForCompositeField
                         "userOauthByRowId"
                         (toGraphQLArguments
                          input)
                         graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserOauthByServiceAndServiceIdentifierInputRowRequired r = ( service :: String
                                                                , serviceIdentifier :: String
                                                                | r
                                                                )

type UserOauthByServiceAndServiceIdentifierInput = {
| UserOauthByServiceAndServiceIdentifierInputRowRequired + ()
}

userOauthByServiceAndServiceIdentifier :: forall r . UserOauthByServiceAndServiceIdentifierInput -> SelectionSet
                                                                                                    Scope__UserOauth
                                                                                                    r -> SelectionSet
                                                                                                         Scope__RootQuery
                                                                                                         (Maybe
                                                                                                          r)
userOauthByServiceAndServiceIdentifier input = selectionForCompositeField
                                               "userOauthByServiceAndServiceIdentifier"
                                               (toGraphQLArguments
                                                input)
                                               graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByRowIdInputRowRequired r = ( rowId :: Uuid | r )

type UserByRowIdInput = { | UserByRowIdInputRowRequired + () }

userByRowId :: forall r . UserByRowIdInput -> SelectionSet
                                              Scope__User
                                              r -> SelectionSet
                                                   Scope__RootQuery
                                                   (Maybe
                                                    r)
userByRowId input = selectionForCompositeField
                    "userByRowId"
                    (toGraphQLArguments
                     input)
                    graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByEmailInputRowRequired r = ( email :: String | r )

type UserByEmailInput = { | UserByEmailInputRowRequired + () }

userByEmail :: forall r . UserByEmailInput -> SelectionSet
                                              Scope__User
                                              r -> SelectionSet
                                                   Scope__RootQuery
                                                   (Maybe
                                                    r)
userByEmail input = selectionForCompositeField
                    "userByEmail"
                    (toGraphQLArguments
                     input)
                    graphqlDefaultResponseFunctorOrScalarDecoderTransformer

currentUser :: forall r . SelectionSet
                          Scope__User
                          r -> SelectionSet
                               Scope__RootQuery
                               (Maybe
                                r)
currentUser = selectionForCompositeField
              "currentUser"
              []
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type PostInputRowRequired r = ( id :: Id | r )

type PostInput = { | PostInputRowRequired + () }

post :: forall r . PostInput -> SelectionSet
                                Scope__Post
                                r -> SelectionSet
                                     Scope__RootQuery
                                     (Maybe
                                      r)
post input = selectionForCompositeField
             "post"
             (toGraphQLArguments
              input)
             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserOauthInputRowRequired r = ( id :: Id | r )

type UserOauthInput = { | UserOauthInputRowRequired + () }

userOauth :: forall r . UserOauthInput -> SelectionSet
                                          Scope__UserOauth
                                          r -> SelectionSet
                                               Scope__RootQuery
                                               (Maybe
                                                r)
userOauth input = selectionForCompositeField
                  "userOauth"
                  (toGraphQLArguments
                   input)
                  graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserInputRowRequired r = ( id :: Id | r )

type UserInput = { | UserInputRowRequired + () }

user :: forall r . UserInput -> SelectionSet
                                Scope__User
                                r -> SelectionSet
                                     Scope__RootQuery
                                     (Maybe
                                      r)
user input = selectionForCompositeField
             "user"
             (toGraphQLArguments
              input)
             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

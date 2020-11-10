module Api.Query where

import GraphQLClient
  ( SelectionSet
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , toGraphQLArguments
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Optional
  )
import Api.Scopes
  ( Scope__User
  , Scope__Node
  , Scope__Post
  , Scope__PostsConnection
  , Scope__UserAuthentication
  , Scope__UserEmail
  )
import Data.Maybe (Maybe)
import Api.Scalars (Id, Uuid, Cursor)
import Type.Row (type (+))
import Api.InputObject (PostCondition) as Api.InputObject
import Api.Enum.PostsOrderBy (PostsOrderBy)

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

type NodeInputRowRequired r = ( nodeId :: Id | r )

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

nodeId :: SelectionSet Scope__RootQuery Id
nodeId = selectionForField "nodeId" [] graphqlDefaultResponseScalarDecoder

type PostInputRowRequired r = ( id :: Uuid | r )

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

type PostByNodeIdInputRowRequired r = ( nodeId :: Id | r )

type PostByNodeIdInput = { | PostByNodeIdInputRowRequired + () }

postByNodeId :: forall r . PostByNodeIdInput -> SelectionSet
                                                Scope__Post
                                                r -> SelectionSet
                                                     Scope__RootQuery
                                                     (Maybe
                                                      r)
postByNodeId input = selectionForCompositeField
                     "postByNodeId"
                     (toGraphQLArguments
                      input)
                     graphqlDefaultResponseFunctorOrScalarDecoderTransformer

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
                                       Scope__RootQuery
                                       (Maybe
                                        r)
posts input = selectionForCompositeField
              "posts"
              (toGraphQLArguments
               input)
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__RootQuery
                         r
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserInputRowRequired r = ( id :: Uuid | r )

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

type UserAuthenticationInputRowRequired r = ( id :: Uuid | r )

type UserAuthenticationInput = { | UserAuthenticationInputRowRequired + () }

userAuthentication :: forall r . UserAuthenticationInput -> SelectionSet
                                                            Scope__UserAuthentication
                                                            r -> SelectionSet
                                                                 Scope__RootQuery
                                                                 (Maybe
                                                                  r)
userAuthentication input = selectionForCompositeField
                           "userAuthentication"
                           (toGraphQLArguments
                            input)
                           graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserAuthenticationByNodeIdInputRowRequired r = ( nodeId :: Id | r )

type UserAuthenticationByNodeIdInput = {
| UserAuthenticationByNodeIdInputRowRequired + ()
}

userAuthenticationByNodeId :: forall r . UserAuthenticationByNodeIdInput -> SelectionSet
                                                                            Scope__UserAuthentication
                                                                            r -> SelectionSet
                                                                                 Scope__RootQuery
                                                                                 (Maybe
                                                                                  r)
userAuthenticationByNodeId input = selectionForCompositeField
                                   "userAuthenticationByNodeId"
                                   (toGraphQLArguments
                                    input)
                                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserAuthenticationByServiceAndIdentifierInputRowRequired r = ( identifier :: String
                                                                  , service :: String
                                                                  | r
                                                                  )

type UserAuthenticationByServiceAndIdentifierInput = {
| UserAuthenticationByServiceAndIdentifierInputRowRequired + ()
}

userAuthenticationByServiceAndIdentifier :: forall r . UserAuthenticationByServiceAndIdentifierInput -> SelectionSet
                                                                                                        Scope__UserAuthentication
                                                                                                        r -> SelectionSet
                                                                                                             Scope__RootQuery
                                                                                                             (Maybe
                                                                                                              r)
userAuthenticationByServiceAndIdentifier input = selectionForCompositeField
                                                 "userAuthenticationByServiceAndIdentifier"
                                                 (toGraphQLArguments
                                                  input)
                                                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByNodeIdInputRowRequired r = ( nodeId :: Id | r )

type UserByNodeIdInput = { | UserByNodeIdInputRowRequired + () }

userByNodeId :: forall r . UserByNodeIdInput -> SelectionSet
                                                Scope__User
                                                r -> SelectionSet
                                                     Scope__RootQuery
                                                     (Maybe
                                                      r)
userByNodeId input = selectionForCompositeField
                     "userByNodeId"
                     (toGraphQLArguments
                      input)
                     graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByUsernameInputRowRequired r = ( username :: String | r )

type UserByUsernameInput = { | UserByUsernameInputRowRequired + () }

userByUsername :: forall r . UserByUsernameInput -> SelectionSet
                                                    Scope__User
                                                    r -> SelectionSet
                                                         Scope__RootQuery
                                                         (Maybe
                                                          r)
userByUsername input = selectionForCompositeField
                       "userByUsername"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserEmailInputRowRequired r = ( id :: Uuid | r )

type UserEmailInput = { | UserEmailInputRowRequired + () }

userEmail :: forall r . UserEmailInput -> SelectionSet
                                          Scope__UserEmail
                                          r -> SelectionSet
                                               Scope__RootQuery
                                               (Maybe
                                                r)
userEmail input = selectionForCompositeField
                  "userEmail"
                  (toGraphQLArguments
                   input)
                  graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserEmailByNodeIdInputRowRequired r = ( nodeId :: Id | r )

type UserEmailByNodeIdInput = { | UserEmailByNodeIdInputRowRequired + () }

userEmailByNodeId :: forall r . UserEmailByNodeIdInput -> SelectionSet
                                                          Scope__UserEmail
                                                          r -> SelectionSet
                                                               Scope__RootQuery
                                                               (Maybe
                                                                r)
userEmailByNodeId input = selectionForCompositeField
                          "userEmailByNodeId"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserEmailByUserIdAndEmailInputRowRequired r = ( email :: String
                                                   , userId :: Uuid
                                                   | r
                                                   )

type UserEmailByUserIdAndEmailInput = {
| UserEmailByUserIdAndEmailInputRowRequired + ()
}

userEmailByUserIdAndEmail :: forall r . UserEmailByUserIdAndEmailInput -> SelectionSet
                                                                          Scope__UserEmail
                                                                          r -> SelectionSet
                                                                               Scope__RootQuery
                                                                               (Maybe
                                                                                r)
userEmailByUserIdAndEmail input = selectionForCompositeField
                                  "userEmailByUserIdAndEmail"
                                  (toGraphQLArguments
                                   input)
                                  graphqlDefaultResponseFunctorOrScalarDecoderTransformer

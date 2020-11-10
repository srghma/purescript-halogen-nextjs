module Api.Object.DeleteUserPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , Optional
  , toGraphQLArguments
  )
import Api.Scopes (Scope__DeleteUserPayload, Scope__User, Scope__UsersEdge)
import Data.Maybe (Maybe)
import Api.Scalars (Id)
import Api.Enum.UsersOrderBy (UsersOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__DeleteUserPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

deletedUserNodeId :: SelectionSet Scope__DeleteUserPayload (Maybe Id)
deletedUserNodeId = selectionForField
                    "deletedUserNodeId"
                    []
                    graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__DeleteUserPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__DeleteUserPayload
                        (Maybe
                         r)
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserEdgeInputRowOptional r = ( orderBy :: Optional (Array UsersOrderBy)
                                  | r
                                  )

type UserEdgeInput = { | UserEdgeInputRowOptional + () }

userEdge :: forall r . UserEdgeInput -> SelectionSet
                                        Scope__UsersEdge
                                        r -> SelectionSet
                                             Scope__DeleteUserPayload
                                             (Maybe
                                              r)
userEdge input = selectionForCompositeField
                 "userEdge"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

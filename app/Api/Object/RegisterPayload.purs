module Api.Object.RegisterPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , Scope__RootQuery
  , Optional
  , toGraphQLArguments
  )
import Api.Scopes (Scope__RegisterPayload, Scope__User, Scope__UsersEdge)
import Data.Maybe (Maybe)
import Api.Enum.UsersOrderBy (UsersOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__RegisterPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__RegisterPayload
                        (Maybe
                         r)
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__RegisterPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserEdgeInputRowOptional r = ( orderBy :: Optional (Array UsersOrderBy)
                                  | r
                                  )

type UserEdgeInput = { | UserEdgeInputRowOptional + () }

userEdge :: forall r . UserEdgeInput -> SelectionSet
                                        Scope__UsersEdge
                                        r -> SelectionSet
                                             Scope__RegisterPayload
                                             (Maybe
                                              r)
userEdge input = selectionForCompositeField
                 "userEdge"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

module Api.Object.UpdateUserPayload where

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
import Api.Scopes (Scope__UpdateUserPayload, Scope__User, Scope__UsersEdge)
import Data.Maybe (Maybe)
import Api.Enum.UsersOrderBy (UsersOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__UpdateUserPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__UpdateUserPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__UpdateUserPayload
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
                                             Scope__UpdateUserPayload
                                             (Maybe
                                              r)
userEdge input = selectionForCompositeField
                 "userEdge"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

module Api.Object.UpdateUserOauthPayload where

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
import Api.Scopes
  (Scope__UpdateUserOauthPayload, Scope__UserOauth, Scope__UserOauthsEdge)
import Data.Maybe (Maybe)
import Api.Enum.UserOauthsOrderBy (UserOauthsOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__UpdateUserOauthPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

userOauth :: forall r . SelectionSet
                        Scope__UserOauth
                        r -> SelectionSet
                             Scope__UpdateUserOauthPayload
                             (Maybe
                              r)
userOauth = selectionForCompositeField
            "userOauth"
            []
            graphqlDefaultResponseFunctorOrScalarDecoderTransformer

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__UpdateUserOauthPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserOauthEdgeInputRowOptional r = ( orderBy :: Optional
                                                    (Array
                                                     UserOauthsOrderBy)
                                       | r
                                       )

type UserOauthEdgeInput = { | UserOauthEdgeInputRowOptional + () }

userOauthEdge :: forall r . UserOauthEdgeInput -> SelectionSet
                                                  Scope__UserOauthsEdge
                                                  r -> SelectionSet
                                                       Scope__UpdateUserOauthPayload
                                                       (Maybe
                                                        r)
userOauthEdge input = selectionForCompositeField
                      "userOauthEdge"
                      (toGraphQLArguments
                       input)
                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer

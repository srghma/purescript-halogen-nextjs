module Api.Object.UpsertPostPayload where

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
  (Scope__UpsertPostPayload, Scope__Post, Scope__User, Scope__PostsEdge)
import Data.Maybe (Maybe)
import Api.Enum.PostsOrderBy (PostsOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__UpsertPostPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

post :: forall r . SelectionSet
                   Scope__Post
                   r -> SelectionSet
                        Scope__UpsertPostPayload
                        (Maybe
                         r)
post = selectionForCompositeField
       "post"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__UpsertPostPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userByUserId :: forall r . SelectionSet
                           Scope__User
                           r -> SelectionSet
                                Scope__UpsertPostPayload
                                (Maybe
                                 r)
userByUserId = selectionForCompositeField
               "userByUserId"
               []
               graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type PostEdgeInputRowOptional r = ( orderBy :: Optional (Array PostsOrderBy)
                                  | r
                                  )

type PostEdgeInput = { | PostEdgeInputRowOptional + () }

postEdge :: forall r . PostEdgeInput -> SelectionSet
                                        Scope__PostsEdge
                                        r -> SelectionSet
                                             Scope__UpsertPostPayload
                                             (Maybe
                                              r)
postEdge input = selectionForCompositeField
                 "postEdge"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

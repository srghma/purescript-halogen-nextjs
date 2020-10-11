module Api.Object.UpdatePostPayload where

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
  (Scope__UpdatePostPayload, Scope__Post, Scope__User, Scope__PostsEdge)
import Data.Maybe (Maybe)
import Api.Enum.PostsOrderBy (PostsOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__UpdatePostPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

post :: forall r . SelectionSet
                   Scope__Post
                   r -> SelectionSet
                        Scope__UpdatePostPayload
                        (Maybe
                         r)
post = selectionForCompositeField
       "post"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__UpdatePostPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userByUserId :: forall r . SelectionSet
                           Scope__User
                           r -> SelectionSet
                                Scope__UpdatePostPayload
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
                                             Scope__UpdatePostPayload
                                             (Maybe
                                              r)
postEdge input = selectionForCompositeField
                 "postEdge"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

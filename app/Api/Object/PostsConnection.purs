module Api.Object.PostsConnection where

import GraphQLClient
  ( SelectionSet
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  )
import Api.Scopes
  (Scope__Post, Scope__PostsConnection, Scope__PostsEdge, Scope__PageInfo)
import Data.Maybe (Maybe)

nodes :: forall r . SelectionSet
                    Scope__Post
                    r -> SelectionSet
                         Scope__PostsConnection
                         (Array
                          (Maybe
                           r))
nodes = selectionForCompositeField
        "nodes"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

edges :: forall r . SelectionSet
                    Scope__PostsEdge
                    r -> SelectionSet
                         Scope__PostsConnection
                         (Array
                          r)
edges = selectionForCompositeField
        "edges"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

pageInfo :: forall r . SelectionSet
                       Scope__PageInfo
                       r -> SelectionSet
                            Scope__PostsConnection
                            r
pageInfo = selectionForCompositeField
           "pageInfo"
           []
           graphqlDefaultResponseFunctorOrScalarDecoderTransformer

totalCount :: SelectionSet Scope__PostsConnection Int
totalCount = selectionForField
             "totalCount"
             []
             graphqlDefaultResponseScalarDecoder

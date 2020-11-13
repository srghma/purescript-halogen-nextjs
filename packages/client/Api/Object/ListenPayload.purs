module Api.Object.ListenPayload where

import GraphQLClient
  ( SelectionSet
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  )
import Api.Scopes (Scope__ListenPayload, Scope__Node)
import Data.Maybe (Maybe)
import Api.Scalars (Id)

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__ListenPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

relatedNode :: forall r . SelectionSet
                          Scope__Node
                          r -> SelectionSet
                               Scope__ListenPayload
                               (Maybe
                                r)
relatedNode = selectionForCompositeField
              "relatedNode"
              []
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

relatedNodeId :: SelectionSet Scope__ListenPayload (Maybe Id)
relatedNodeId = selectionForField
                "relatedNodeId"
                []
                graphqlDefaultResponseScalarDecoder

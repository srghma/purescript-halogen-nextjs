module NextjsGraphqlApi.Object.UserEmailsConnection where

import GraphQLClient
  ( SelectionSet
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  )
import NextjsGraphqlApi.Scopes
  ( Scope__UserEmailsEdge
  , Scope__UserEmailsConnection
  , Scope__UserEmail
  , Scope__PageInfo
  )

edges :: forall r . SelectionSet
                    Scope__UserEmailsEdge
                    r -> SelectionSet
                         Scope__UserEmailsConnection
                         (Array
                          r)
edges = selectionForCompositeField
        "edges"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

nodes :: forall r . SelectionSet
                    Scope__UserEmail
                    r -> SelectionSet
                         Scope__UserEmailsConnection
                         (Array
                          r)
nodes = selectionForCompositeField
        "nodes"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

pageInfo :: forall r . SelectionSet
                       Scope__PageInfo
                       r -> SelectionSet
                            Scope__UserEmailsConnection
                            r
pageInfo = selectionForCompositeField
           "pageInfo"
           []
           graphqlDefaultResponseFunctorOrScalarDecoderTransformer

totalCount :: SelectionSet Scope__UserEmailsConnection Int
totalCount = selectionForField
             "totalCount"
             []
             graphqlDefaultResponseScalarDecoder

module Api.Object.UpsertUserEmailPayload where

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
import Api.Scopes
  ( Scope__UpsertUserEmailPayload
  , Scope__User
  , Scope__UserEmail
  , Scope__UserEmailsEdge
  )
import Data.Maybe (Maybe)
import Api.Enum.UserEmailsOrderBy (UserEmailsOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__UpsertUserEmailPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__UpsertUserEmailPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__UpsertUserEmailPayload
                        (Maybe
                         r)
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userEmail :: forall r . SelectionSet
                        Scope__UserEmail
                        r -> SelectionSet
                             Scope__UpsertUserEmailPayload
                             (Maybe
                              r)
userEmail = selectionForCompositeField
            "userEmail"
            []
            graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserEmailEdgeInputRowOptional r = ( orderBy :: Optional
                                                    (Array
                                                     UserEmailsOrderBy)
                                       | r
                                       )

type UserEmailEdgeInput = { | UserEmailEdgeInputRowOptional + () }

userEmailEdge :: forall r . UserEmailEdgeInput -> SelectionSet
                                                  Scope__UserEmailsEdge
                                                  r -> SelectionSet
                                                       Scope__UpsertUserEmailPayload
                                                       (Maybe
                                                        r)
userEmailEdge input = selectionForCompositeField
                      "userEmailEdge"
                      (toGraphQLArguments
                       input)
                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer

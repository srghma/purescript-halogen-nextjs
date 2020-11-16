module NextjsGraphqlApi.Object.DeleteUserEmailPayload where

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
import NextjsGraphqlApi.Scopes
  ( Scope__DeleteUserEmailPayload
  , Scope__User
  , Scope__UserEmail
  , Scope__UserEmailsEdge
  )
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Id)
import NextjsGraphqlApi.Enum.UserEmailsOrderBy (UserEmailsOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet Scope__DeleteUserEmailPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

deletedUserEmailId :: SelectionSet Scope__DeleteUserEmailPayload (Maybe Id)
deletedUserEmailId = selectionForField
                     "deletedUserEmailId"
                     []
                     graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__DeleteUserEmailPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__DeleteUserEmailPayload
                        (Maybe
                         r)
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userEmail :: forall r . SelectionSet
                        Scope__UserEmail
                        r -> SelectionSet
                             Scope__DeleteUserEmailPayload
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
                                                       Scope__DeleteUserEmailPayload
                                                       (Maybe
                                                        r)
userEmailEdge input = selectionForCompositeField
                      "userEmailEdge"
                      (toGraphQLArguments
                       input)
                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer
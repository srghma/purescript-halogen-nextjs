module Api.Enum.UserOauthsOrderBy where

import Prelude (class Eq, class Ord)
import Data.Tuple (Tuple(..))
import GraphQLClient
  ( class GraphQLDefaultResponseScalarDecoder
  , enumDecoder
  , class ToGraphQLArgumentValue
  , ArgumentValue(..)
  )

-- | original name - UserOauthsOrderBy
data UserOauthsOrderBy
  = Natural
  | IdAsc
  | IdDesc
  | ServiceAsc
  | ServiceDesc
  | ServiceIdentifierAsc
  | ServiceIdentifierDesc
  | CreatedAtAsc
  | CreatedAtDesc
  | UpdatedAtAsc
  | UpdatedAtDesc
  | PrimaryKeyAsc
  | PrimaryKeyDesc

derive instance eqUserOauthsOrderBy :: Eq UserOauthsOrderBy

derive instance ordUserOauthsOrderBy :: Ord UserOauthsOrderBy

fromToMap :: Array (Tuple String UserOauthsOrderBy)
fromToMap = [ Tuple "NATURAL" Natural
            , Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "SERVICE_ASC" ServiceAsc
            , Tuple "SERVICE_DESC" ServiceDesc
            , Tuple "SERVICE_IDENTIFIER_ASC" ServiceIdentifierAsc
            , Tuple "SERVICE_IDENTIFIER_DESC" ServiceIdentifierDesc
            , Tuple "CREATED_AT_ASC" CreatedAtAsc
            , Tuple "CREATED_AT_DESC" CreatedAtDesc
            , Tuple "UPDATED_AT_ASC" UpdatedAtAsc
            , Tuple "UPDATED_AT_DESC" UpdatedAtDesc
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            ]

instance userOauthsOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                                 UserOauthsOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder
                                        "UserOauthsOrderBy"
                                        fromToMap

instance userOauthsOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                                    UserOauthsOrderBy where
  toGraphQLArgumentValue =
    case _ of
      Natural -> ArgumentValueEnum "NATURAL"
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      ServiceAsc -> ArgumentValueEnum "SERVICE_ASC"
      ServiceDesc -> ArgumentValueEnum "SERVICE_DESC"
      ServiceIdentifierAsc -> ArgumentValueEnum "SERVICE_IDENTIFIER_ASC"
      ServiceIdentifierDesc -> ArgumentValueEnum "SERVICE_IDENTIFIER_DESC"
      CreatedAtAsc -> ArgumentValueEnum "CREATED_AT_ASC"
      CreatedAtDesc -> ArgumentValueEnum "CREATED_AT_DESC"
      UpdatedAtAsc -> ArgumentValueEnum "UPDATED_AT_ASC"
      UpdatedAtDesc -> ArgumentValueEnum "UPDATED_AT_DESC"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"

module NextjsGraphqlApi.Enum.UserEmailsOrderBy where

import Data.Generic.Rep (class Generic)
import Data.Show (class Show)
import Data.Generic.Rep.Show (genericShow)
import Prelude
import Data.Tuple (Tuple(..))
import GraphQLClient
  ( class GraphQLDefaultResponseScalarDecoder
  , enumDecoder
  , class ToGraphQLArgumentValue
  , ArgumentValue(..)
  )

-- | original name - UserEmailsOrderBy
data UserEmailsOrderBy
  = IdAsc
  | IdDesc
  | Natural
  | PrimaryKeyAsc
  | PrimaryKeyDesc
  | UserIdAsc
  | UserIdDesc

derive instance genericUserEmailsOrderBy :: Generic UserEmailsOrderBy _

instance showUserEmailsOrderBy :: Show UserEmailsOrderBy where
  show = genericShow

derive instance eqUserEmailsOrderBy :: Eq UserEmailsOrderBy

derive instance ordUserEmailsOrderBy :: Ord UserEmailsOrderBy

fromToMap :: Array (Tuple String UserEmailsOrderBy)
fromToMap = [ Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "NATURAL" Natural
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            , Tuple "USER_ID_ASC" UserIdAsc
            , Tuple "USER_ID_DESC" UserIdDesc
            ]

instance userEmailsOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                                 UserEmailsOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder
                                        "UserEmailsOrderBy"
                                        fromToMap

instance userEmailsOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                                    UserEmailsOrderBy where
  toGraphQLArgumentValue =
    case _ of
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      Natural -> ArgumentValueEnum "NATURAL"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"
      UserIdAsc -> ArgumentValueEnum "USER_ID_ASC"
      UserIdDesc -> ArgumentValueEnum "USER_ID_DESC"

module Api.Enum.PostsOrderBy where

import Prelude (class Eq, class Ord)
import Data.Tuple (Tuple(..))
import GraphQLClient
  ( class GraphQLDefaultResponseScalarDecoder
  , enumDecoder
  , class ToGraphQLArgumentValue
  , ArgumentValue(..)
  )

-- | original name - PostsOrderBy
data PostsOrderBy
  = Natural
  | IdAsc
  | IdDesc
  | NameAsc
  | NameDesc
  | ContentAsc
  | ContentDesc
  | UserIdAsc
  | UserIdDesc
  | CreatedAtAsc
  | CreatedAtDesc
  | UpdatedAtAsc
  | UpdatedAtDesc
  | PrimaryKeyAsc
  | PrimaryKeyDesc

derive instance eqPostsOrderBy :: Eq PostsOrderBy

derive instance ordPostsOrderBy :: Ord PostsOrderBy

fromToMap :: Array (Tuple String PostsOrderBy)
fromToMap = [ Tuple "NATURAL" Natural
            , Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "NAME_ASC" NameAsc
            , Tuple "NAME_DESC" NameDesc
            , Tuple "CONTENT_ASC" ContentAsc
            , Tuple "CONTENT_DESC" ContentDesc
            , Tuple "USER_ID_ASC" UserIdAsc
            , Tuple "USER_ID_DESC" UserIdDesc
            , Tuple "CREATED_AT_ASC" CreatedAtAsc
            , Tuple "CREATED_AT_DESC" CreatedAtDesc
            , Tuple "UPDATED_AT_ASC" UpdatedAtAsc
            , Tuple "UPDATED_AT_DESC" UpdatedAtDesc
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            ]

instance postsOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                            PostsOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder "PostsOrderBy" fromToMap

instance postsOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                               PostsOrderBy where
  toGraphQLArgumentValue =
    case _ of
      Natural -> ArgumentValueEnum "NATURAL"
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      NameAsc -> ArgumentValueEnum "NAME_ASC"
      NameDesc -> ArgumentValueEnum "NAME_DESC"
      ContentAsc -> ArgumentValueEnum "CONTENT_ASC"
      ContentDesc -> ArgumentValueEnum "CONTENT_DESC"
      UserIdAsc -> ArgumentValueEnum "USER_ID_ASC"
      UserIdDesc -> ArgumentValueEnum "USER_ID_DESC"
      CreatedAtAsc -> ArgumentValueEnum "CREATED_AT_ASC"
      CreatedAtDesc -> ArgumentValueEnum "CREATED_AT_DESC"
      UpdatedAtAsc -> ArgumentValueEnum "UPDATED_AT_ASC"
      UpdatedAtDesc -> ArgumentValueEnum "UPDATED_AT_DESC"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"

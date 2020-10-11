module Api.Enum.UsersOrderBy where

import Prelude (class Eq, class Ord)
import Data.Tuple (Tuple(..))
import GraphQLClient
  ( class GraphQLDefaultResponseScalarDecoder
  , enumDecoder
  , class ToGraphQLArgumentValue
  , ArgumentValue(..)
  )

-- | original name - UsersOrderBy
data UsersOrderBy
  = Natural
  | IdAsc
  | IdDesc
  | FirstNameAsc
  | FirstNameDesc
  | LastNameAsc
  | LastNameDesc
  | EmailAsc
  | EmailDesc
  | AvatarUrlAsc
  | AvatarUrlDesc
  | IsConfirmedAsc
  | IsConfirmedDesc
  | CreatedAtAsc
  | CreatedAtDesc
  | UpdatedAtAsc
  | UpdatedAtDesc
  | PrimaryKeyAsc
  | PrimaryKeyDesc

derive instance eqUsersOrderBy :: Eq UsersOrderBy

derive instance ordUsersOrderBy :: Ord UsersOrderBy

fromToMap :: Array (Tuple String UsersOrderBy)
fromToMap = [ Tuple "NATURAL" Natural
            , Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "FIRST_NAME_ASC" FirstNameAsc
            , Tuple "FIRST_NAME_DESC" FirstNameDesc
            , Tuple "LAST_NAME_ASC" LastNameAsc
            , Tuple "LAST_NAME_DESC" LastNameDesc
            , Tuple "EMAIL_ASC" EmailAsc
            , Tuple "EMAIL_DESC" EmailDesc
            , Tuple "AVATAR_URL_ASC" AvatarUrlAsc
            , Tuple "AVATAR_URL_DESC" AvatarUrlDesc
            , Tuple "IS_CONFIRMED_ASC" IsConfirmedAsc
            , Tuple "IS_CONFIRMED_DESC" IsConfirmedDesc
            , Tuple "CREATED_AT_ASC" CreatedAtAsc
            , Tuple "CREATED_AT_DESC" CreatedAtDesc
            , Tuple "UPDATED_AT_ASC" UpdatedAtAsc
            , Tuple "UPDATED_AT_DESC" UpdatedAtDesc
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            ]

instance usersOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                            UsersOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder "UsersOrderBy" fromToMap

instance usersOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                               UsersOrderBy where
  toGraphQLArgumentValue =
    case _ of
      Natural -> ArgumentValueEnum "NATURAL"
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      FirstNameAsc -> ArgumentValueEnum "FIRST_NAME_ASC"
      FirstNameDesc -> ArgumentValueEnum "FIRST_NAME_DESC"
      LastNameAsc -> ArgumentValueEnum "LAST_NAME_ASC"
      LastNameDesc -> ArgumentValueEnum "LAST_NAME_DESC"
      EmailAsc -> ArgumentValueEnum "EMAIL_ASC"
      EmailDesc -> ArgumentValueEnum "EMAIL_DESC"
      AvatarUrlAsc -> ArgumentValueEnum "AVATAR_URL_ASC"
      AvatarUrlDesc -> ArgumentValueEnum "AVATAR_URL_DESC"
      IsConfirmedAsc -> ArgumentValueEnum "IS_CONFIRMED_ASC"
      IsConfirmedDesc -> ArgumentValueEnum "IS_CONFIRMED_DESC"
      CreatedAtAsc -> ArgumentValueEnum "CREATED_AT_ASC"
      CreatedAtDesc -> ArgumentValueEnum "CREATED_AT_DESC"
      UpdatedAtAsc -> ArgumentValueEnum "UPDATED_AT_ASC"
      UpdatedAtDesc -> ArgumentValueEnum "UPDATED_AT_DESC"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"

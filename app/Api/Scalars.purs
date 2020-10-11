module Api.Scalars where

import Prelude (class Eq, class Ord, class Show)
import Data.Newtype (class Newtype)
import GraphQLClient
  (class GraphQLDefaultResponseScalarDecoder, class ToGraphQLArgumentValue)

-- | original name - ID
newtype Id = Id String

derive newtype instance eqId :: Eq Id

derive newtype instance ordId :: Ord Id

derive newtype instance showId :: Show Id

derive instance newtypeId :: Newtype Id _

derive newtype instance graphQlDefaultResponseScalarDecoderId :: GraphQLDefaultResponseScalarDecoder Id

derive newtype instance toGraphQlArgumentValueId :: ToGraphQLArgumentValue Id

-- | original name - Cursor
newtype Cursor = Cursor String

derive newtype instance eqCursor :: Eq Cursor

derive newtype instance ordCursor :: Ord Cursor

derive newtype instance showCursor :: Show Cursor

derive instance newtypeCursor :: Newtype Cursor _

derive newtype instance graphQlDefaultResponseScalarDecoderCursor :: GraphQLDefaultResponseScalarDecoder Cursor

derive newtype instance toGraphQlArgumentValueCursor :: ToGraphQLArgumentValue Cursor

-- | original name - UUID
newtype Uuid = Uuid String

derive newtype instance eqUuid :: Eq Uuid

derive newtype instance ordUuid :: Ord Uuid

derive newtype instance showUuid :: Show Uuid

derive instance newtypeUuid :: Newtype Uuid _

derive newtype instance graphQlDefaultResponseScalarDecoderUuid :: GraphQLDefaultResponseScalarDecoder Uuid

derive newtype instance toGraphQlArgumentValueUuid :: ToGraphQLArgumentValue Uuid

-- | original name - Datetime
newtype Datetime = Datetime String

derive newtype instance eqDatetime :: Eq Datetime

derive newtype instance ordDatetime :: Ord Datetime

derive newtype instance showDatetime :: Show Datetime

derive instance newtypeDatetime :: Newtype Datetime _

derive newtype instance graphQlDefaultResponseScalarDecoderDatetime :: GraphQLDefaultResponseScalarDecoder Datetime

derive newtype instance toGraphQlArgumentValueDatetime :: ToGraphQLArgumentValue Datetime

-- | original name - Jwt
newtype Jwt = Jwt String

derive newtype instance eqJwt :: Eq Jwt

derive newtype instance ordJwt :: Ord Jwt

derive newtype instance showJwt :: Show Jwt

derive instance newtypeJwt :: Newtype Jwt _

derive newtype instance graphQlDefaultResponseScalarDecoderJwt :: GraphQLDefaultResponseScalarDecoder Jwt

derive newtype instance toGraphQlArgumentValueJwt :: ToGraphQLArgumentValue Jwt

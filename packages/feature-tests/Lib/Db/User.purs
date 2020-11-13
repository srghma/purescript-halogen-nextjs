module Lib.Db.User where

import Prelude
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Database.PostgreSQL
import Data.Either
import Data.Array

type UserID
  = Int

newtype User
  = User
  { id :: UserID
  , name :: String
  }

derive instance genericUser :: Generic User _

instance showUser :: Show User where
  show = genericShow

instance decodeUser :: Decode User where
  decode = genericDecode $ defaultOptions { unwrapSingleConstructors = true }

instance encodeUser :: Encode User where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

instance userFromSQLRow :: FromSQLRow User where
  fromSQLRow [ id, name ] = User <$> ({ id: _, name: _ } <$> fromSQLValue id <*> fromSQLValue name)
  fromSQLRow xs = Left $ "Row has " <> show n <> " fields, expecting 2."
    where
    n = length xs

instance userToSQLRow :: ToSQLRow User where
  toSQLRow (User { id, name }) = [ toSQLValue id, toSQLValue name ]

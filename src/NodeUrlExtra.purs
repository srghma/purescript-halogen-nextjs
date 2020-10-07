module NodeUrlExtra where

import Protolude
import Node.URL (Query)
import Node.URL as Node.URL
import Foreign.Object (Object)
import Foreign.Object as Object
import Unsafe.Coerce (unsafeCoerce)

-- | Should be one level
toQuery :: Object String -> Query
toQuery = unsafeCoerce

fromQuery :: Query -> Object String
fromQuery = unsafeCoerce


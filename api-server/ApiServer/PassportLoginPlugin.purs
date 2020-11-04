module ApiServer.PassportLoginPlugin where

import Postgraphile

foreign import passportLoginPlugin :: PostgraphileAppendPlugin

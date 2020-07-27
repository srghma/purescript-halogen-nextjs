module Nextjs.Lib.Api where

import Protolude

import Affjax as Affjax
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode (JsonDecodeError, printJsonDecodeError) as ArgonautCodecs

data ApiError
  = ApiAffjaxError Affjax.Error
  | ApiJsonDecodeError ArgonautCodecs.JsonDecodeError ArgonautCore.Json

throwApiError :: forall a . ApiError -> Aff a
throwApiError (ApiAffjaxError affjaxError) = throwError $ error $ Affjax.printError affjaxError
throwApiError (ApiJsonDecodeError jsonDecodeError json) = throwError $ error $ ArgonautCodecs.printJsonDecodeError jsonDecodeError

tryDecodeResponse
  :: forall a
   . (ArgonautCore.Json -> Either ArgonautCodecs.JsonDecodeError a)
  -> Either Affjax.Error (Affjax.Response ArgonautCore.Json)
  -> Either ApiError a
tryDecodeResponse decode =
  case _ of
    Left error -> Left $ ApiAffjaxError error
    Right response ->
      let (json :: ArgonautCore.Json) = response.body
       in case decode json of
         Left error -> Left $ ApiJsonDecodeError error json
         Right output -> Right output

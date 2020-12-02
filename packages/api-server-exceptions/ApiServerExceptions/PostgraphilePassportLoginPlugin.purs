module ApiServerExceptions.PostgraphilePassportLoginPlugin where

import Database.PostgreSQL

import Data.Maybe (Maybe(..))
import Effect.Exception (Error)
import Foreign (MultipleErrors)

data WebLoginExceptionsServer
  = WebLoginExceptionsServer__Internal__CannotDecodeInput MultipleErrors
  | WebLoginExceptionsServer__Internal__CannotCreateDbConnect PGError
  | WebLoginExceptionsServer__Internal__LoginFailed PGError -- internal???
  | WebLoginExceptionsServer__Internal__Login__ExpectedArrayWith1Elem
  | WebLoginExceptionsServer__LoginFailed
  | WebLoginExceptionsServer__Internal__SetId PGError
  | WebLoginExceptionsServer__Internal__PassportLoginError Error

data WebLoginExceptionsClient
  = WebLoginExceptionsClient__Internal
  | WebLoginExceptionsClient__LoginFailed

webLoginExceptionsClientToString :: WebLoginExceptionsClient -> String
webLoginExceptionsClientToString =
  case _ of
       WebLoginExceptionsClient__Internal -> "internal_error"
       WebLoginExceptionsClient__LoginFailed -> "login_failed"

webLoginExceptionsClientFromString :: String -> Maybe WebLoginExceptionsClient
webLoginExceptionsClientFromString =
  case _ of
       "internal_error" -> Just WebLoginExceptionsClient__Internal
       "login_failed" -> Just WebLoginExceptionsClient__LoginFailed
       _ -> Nothing

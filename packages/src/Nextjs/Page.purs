module Nextjs.Page where

import Protolude

import Affjax as Affjax
import Affjax.RequestHeader as Affjax
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson) as ArgonautCodecs
import Data.Argonaut.Encode (class EncodeJson, encodeJson) as ArgonautCodecs
import GraphQLClient as GraphQLClient
import Halogen as Halogen
import NextjsApp.AppM (AppM)
import Unsafe.Coerce (unsafeCoerce)
import Web.XHR.XMLHttpRequest (withCredentials)

-- in next.js pages have be 3 types
-- | λ  (Server)  server-side renders at runtime (uses getInitialProps or getServerSideProps)
-- | ○  (Static)  automatically rendered as static HTML (uses no initial props)
-- | ●  (SSG, server site generated)     automatically generated as static HTML + JSON (uses getStaticProps)

data PageData_DynamicRequestOptions
  = PageData_DynamicRequestOptions__Server { sessionHeader :: Maybe (Tuple String String) } -- session header from cookie
  | PageData_DynamicRequestOptions__Client -- should map to { withCredentials = true }
  | PageData_DynamicRequestOptions__Mobile { sessionHeader :: Maybe (Tuple String String) } -- session header from secure storage

dynamicPageData__RequestOptions__To__RequestOptions :: PageData_DynamicRequestOptions -> GraphQLClient.RequestOptions
dynamicPageData__RequestOptions__To__RequestOptions =
  case _ of
       PageData_DynamicRequestOptions__Server { sessionHeader } -> sessionHeaderToHeaders sessionHeader
       PageData_DynamicRequestOptions__Client -> GraphQLClient.defaultRequestOptions { withCredentials = true }
       PageData_DynamicRequestOptions__Mobile { sessionHeader } -> sessionHeaderToHeaders sessionHeader

  where
    sessionHeaderToHeaders =
      case _ of
           Just (Tuple sessionHeaderKey sessionHeaderValue) -> GraphQLClient.defaultRequestOptions { headers = [Affjax.RequestHeader sessionHeaderKey sessionHeaderValue] }
           Nothing -> GraphQLClient.defaultRequestOptions

data PageData_DynamicResponse input
  = PageData_DynamicResponse__Error String -- TODO: request status?
  | PageData_DynamicResponse__Redirect
    { redirectToLocation :: String
    , logout :: Boolean
    }
  | PageData_DynamicResponse__Success input

data PageData input
  = PageData__Dynamic
    { request :: PageData_DynamicRequestOptions -> Aff (PageData_DynamicResponse input)
    , codec :: PageData_DynamicCodec input
    }
  | PageData__Static input
  -- | | ServerLoadedPageData (Aff input) -- TODO?

-- on server - used decoder
-- on client - used encoder (on first page load) OR nothing is used
-- on mobile - nothing is used
type PageData_DynamicCodec a
  = { encoder :: a -> ArgonautCore.Json
    , decoder :: ArgonautCore.Json -> Either ArgonautCodecs.JsonDecodeError a
    }

mkPageData_DynamicCodec ::
  forall input.
  ArgonautCodecs.EncodeJson input =>
  ArgonautCodecs.DecodeJson input =>
  PageData_DynamicCodec input
mkPageData_DynamicCodec = { encoder: ArgonautCodecs.encodeJson, decoder: ArgonautCodecs.decodeJson }

type PageSpecRows input
  = ( pageData :: PageData input
    , component :: Halogen.Component (Const Void) input Void AppM
    , title :: String
    )

type PageSpec input
  = Record (PageSpecRows input)

newtype Page
  = Page (forall input. PageSpec input)

mkPage ::
  forall input.
  ArgonautCodecs.EncodeJson input =>
  ArgonautCodecs.DecodeJson input =>
  PageSpec input ->
  Page
mkPage = unsafeCoerce

unPage ::
  forall r.
  (forall input. PageSpec input -> r) ->
  Page ->
  r
unPage f (Page r) = f r

---------------
type PageSpecWithInput input
  = { input :: input
    , component :: Halogen.Component (Const Void) input Void AppM
    , title :: String
    }

newtype PageSpecWithInputBoxed
  = PageSpecWithInputBoxed (forall input. PageSpecWithInput input)

mkPageSpecWithInputBoxed ::
  forall input.
  PageSpecWithInput input ->
  PageSpecWithInputBoxed
mkPageSpecWithInputBoxed = unsafeCoerce

unPageSpecWithInputBoxed ::
  forall r.
  (forall input. PageSpecWithInput input -> r) ->
  PageSpecWithInputBoxed ->
  r
unPageSpecWithInputBoxed f (PageSpecWithInputBoxed r) = f r

data PageToPageSpecWithInputBoxed_Response
  = PageToPageSpecWithInputBoxed_Response__Error String
  | PageToPageSpecWithInputBoxed_Response__Success PageSpecWithInputBoxed
  | PageToPageSpecWithInputBoxed_Response__Redirect
    { redirectToLocation :: String
    -- on client - ignored
    -- on server - Set-Cookie sessionId "" is set
    -- on mobile - jwt is removed from secure storage
    , logout :: Boolean
    }

pageToPageSpecWithInputBoxed_request :: PageData_DynamicRequestOptions -> Page -> Aff PageToPageSpecWithInputBoxed_Response
pageToPageSpecWithInputBoxed_request requestOptions =
  unPage
    ( \page ->
        case page.pageData of
             PageData__Dynamic { request } ->
               request requestOptions
                 <#> case _ of
                         PageData_DynamicResponse__Error error -> PageToPageSpecWithInputBoxed_Response__Error error
                         PageData_DynamicResponse__Redirect x -> PageToPageSpecWithInputBoxed_Response__Redirect x
                         PageData_DynamicResponse__Success input ->
                           PageToPageSpecWithInputBoxed_Response__Success
                           $ mkPageSpecWithInputBoxed
                             { input
                             , component: page.component
                             , title: page.title
                             }
             PageData__Static input ->
               pure
               $ PageToPageSpecWithInputBoxed_Response__Success
               $ mkPageSpecWithInputBoxed
                 { input
                 , component: page.component
                 , title: page.title
                 }
    )

pageToPageSpecWithInputBoxed_GivenInitialJson_Client :: Aff ArgonautCore.Json -> Page -> Aff (Either ArgonautCodecs.JsonDecodeError PageSpecWithInputBoxed)
pageToPageSpecWithInputBoxed_GivenInitialJson_Client loadJson =
  unPage
    ( \page ->
        case page.pageData of
          PageData__Dynamic { codec } -> do
            loadJson
            <#> \json -> codec.decoder json
            <#> \input ->
              mkPageSpecWithInputBoxed
                { input
                , component: page.component
                , title: page.title
                }
          PageData__Static input ->
            pure $ Right $ mkPageSpecWithInputBoxed
                  { input
                  , component: page.component
                  , title: page.title
                  }
    )

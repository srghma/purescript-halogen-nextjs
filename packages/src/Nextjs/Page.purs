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

data DynamicPageData_RequestOptions
  = DynamicPageData_RequestOptions__Server { sessionHeader :: Tuple String String } -- session header from cookie
  | DynamicPageData_RequestOptions__Client -- should map to { withCredentials = true }
  | DynamicPageData_RequestOptions__Mobile { sessionHeader :: Tuple String String } -- session header from secure storage

dynamicPageData__RequestOptions__To__RequestOptions :: DynamicPageData_RequestOptions -> GraphQLClient.RequestOptions
dynamicPageData__RequestOptions__To__RequestOptions =
  case _ of
       DynamicPageData_RequestOptions__Server { sessionHeader: (Tuple sessionHeaderKey sessionHeaderValue) } -> GraphQLClient.defaultRequestOptions { headers = [Affjax.RequestHeader sessionHeaderKey sessionHeaderValue] }
       DynamicPageData_RequestOptions__Client                                                                -> GraphQLClient.defaultRequestOptions { withCredentials = true }
       DynamicPageData_RequestOptions__Mobile { sessionHeader: (Tuple sessionHeaderKey sessionHeaderValue) } -> GraphQLClient.defaultRequestOptions { headers = [Affjax.RequestHeader sessionHeaderKey sessionHeaderValue] }

data DynamicPageData_Response input
  = DynamicPageData_Response__Error String
  | DynamicPageData_Response__Redirect
    { redirectToLocation :: String
    , logout :: Boolean
    }
  | DynamicPageData_Response__Success input

data PageData input
  = DynamicPageData
    { request ::
        { requestOptions :: DynamicPageData_RequestOptions
        } ->
        Aff (DynamicPageData_Response input)
    , codec :: DynamicPageData_Codec input
    }
  | StaticPageData input
  -- | | ServerLoadedPageData (Aff input) -- TODO?

-- on server - used decoder
-- on client - used encoder (on first page load) OR nothing is used
-- on mobile - nothing is used
type DynamicPageData_Codec a
  = { encoder :: a -> ArgonautCore.Json
    , decoder :: ArgonautCore.Json -> Either ArgonautCodecs.JsonDecodeError a
    }

mkDynamicPageData_Codec ::
  forall input.
  ArgonautCodecs.EncodeJson input =>
  ArgonautCodecs.DecodeJson input =>
  DynamicPageData_Codec input
mkDynamicPageData_Codec = { encoder: ArgonautCodecs.encodeJson, decoder: ArgonautCodecs.decodeJson }

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
    , logout :: Boolean
    }

pageToPageSpecWithInputBoxed :: DynamicPageData_RequestOptions -> Page -> Aff PageToPageSpecWithInputBoxed_Response
pageToPageSpecWithInputBoxed requestOptions =
  unPage
    ( \page ->
        case page.pageData of
             DynamicPageData { request } ->
               request { requestOptions }
                 <#> case _ of
                         DynamicPageData_Response__Error error -> PageToPageSpecWithInputBoxed_Response__Error error
                         DynamicPageData_Response__Redirect x -> PageToPageSpecWithInputBoxed_Response__Redirect x
                         DynamicPageData_Response__Success input ->
                           PageToPageSpecWithInputBoxed_Response__Success
                           $ mkPageSpecWithInputBoxed
                             { input
                             , component: page.component
                             , title: page.title
                             }
             StaticPageData input ->
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
          DynamicPageData { codec } -> do
            loadJson
            <#> \json -> codec.decoder json
            <#> \input ->
              mkPageSpecWithInputBoxed
                { input
                , component: page.component
                , title: page.title
                }
          StaticPageData input ->
            pure $ Right $ mkPageSpecWithInputBoxed
                  { input
                  , component: page.component
                  , title: page.title
                  }
    )

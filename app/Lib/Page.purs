module Nextjs.Lib.Page where

import Nextjs.AppM
import Protolude

import Affjax as Affjax
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Argonaut.Encode as ArgonautCodecs
import Halogen as Halogen
import Nextjs.Lib.Api as Nextjs.Lib.Api
import Record.Builder (build, merge)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

-- in next.js pages have be 3 types
-- | λ  (Server)  server-side renders at runtime (uses getInitialProps or getServerSideProps)
-- | ○  (Static)  automatically rendered as static HTML (uses no initial props)
-- | ●  (SSG, server site generated)     automatically generated as static HTML + JSON (uses getStaticProps)

data PageData input
  = DynamicPageData
    { codec :: Codec input
    , request :: Aff (Either Affjax.Error (Affjax.Response ArgonautCore.Json))
    }
  | StaticPageData input
  -- | | ServerLoadedPageData (Aff input) -- TODO?

type Codec a =
  { encoder :: a -> ArgonautCore.Json
  , decoder :: ArgonautCore.Json -> Either ArgonautCodecs.JsonDecodeError a
  }

mkCodec
  :: forall input
   . ArgonautCodecs.EncodeJson input
  => ArgonautCodecs.DecodeJson input
  => Codec input
mkCodec = { encoder: ArgonautCodecs.encodeJson, decoder: ArgonautCodecs.decodeJson }

type PageSpecRows input =
  ( pageData :: PageData input
  , component :: Halogen.Component (Const Void) input Void AppM
  , title :: String
  )

type PageSpec input = Record (PageSpecRows input)

newtype Page = Page (forall input. PageSpec input)

mkPage
  :: forall input
   . ArgonautCodecs.EncodeJson input
  => ArgonautCodecs.DecodeJson input
  => PageSpec input
  -> Page
mkPage = unsafeCoerce

unPage
  :: forall r
   . (forall input. PageSpec input -> r)
  -> Page
  -> r
unPage f (Page r) = f r

---------------

type PageSpecWithInput input =
  { input :: input
  , component :: Halogen.Component (Const Void) input Void AppM
  , title :: String
  }

newtype PageSpecWithInputBoxed = PageSpecWithInputBoxed (forall input. PageSpecWithInput input)

mkPageSpecWithInputBoxed
  :: forall input
   . PageSpecWithInput input
  -> PageSpecWithInputBoxed
mkPageSpecWithInputBoxed = unsafeCoerce

unPageSpecWithInputBoxed
  :: forall r
   . (forall input. PageSpecWithInput input -> r)
  -> PageSpecWithInputBoxed
  -> r
unPageSpecWithInputBoxed f (PageSpecWithInputBoxed r) = f r

----

-- | data PageWithInput
-- |   = StaticPageWithInput PageSpecWithInputBoxed
-- |   | FromJsonPageWithInput (ArgonautCore.Json -> Either ArgonautCodecs.JsonDecodeError PageSpecWithInputBoxed)

-- | pageToPageWithInput :: Page -> PageWithInput
-- | pageToPageWithInput =
-- |   unPage (\page ->
-- |     case page.pageData of
-- |       (DynamicPageData _) -> FromJsonPageWithInput (\json ->
-- |         page.pageDataCodec.decoder json #
-- |         map (\input -> mkPageSpecWithInputBoxed
-- |             { input
-- |             , component: page.component
-- |             , title: page.title
-- |             }))
-- |       (StaticPageData input) ->
-- |         StaticPageWithInput $ mkPageSpecWithInputBoxed
-- |           { input
-- |           , component: page.component
-- |           , title: page.title
-- |           }
-- |     )

pageToPageSpecWithInputBoxed :: Page -> Aff (Nextjs.Lib.Api.ApiError \/ PageSpecWithInputBoxed)
pageToPageSpecWithInputBoxed =
  unPage (\page ->
    case page.pageData of
      (DynamicPageData { request, codec }) -> do
         (response :: Either Affjax.Error (Affjax.Response ArgonautCore.Json)) <- request

         let response' = Nextjs.Lib.Api.tryDecodeResponse codec.decoder response

         pure $ response' <#> (\input -> mkPageSpecWithInputBoxed
             { input
             , component: page.component
             , title: page.title
             })
      (StaticPageData input) ->
        pure $ Right $ mkPageSpecWithInputBoxed
          { input
          , component: page.component
          , title: page.title
          }
    )

pageToPageSpecWithInputBoxedWivenInitialJson :: Aff ArgonautCore.Json -> Page -> Aff (ArgonautCodecs.JsonDecodeError \/ PageSpecWithInputBoxed)
pageToPageSpecWithInputBoxedWivenInitialJson loadJson =
  unPage (\page ->
    case page.pageData of
      (DynamicPageData { codec }) -> do
         (json :: ArgonautCore.Json) <- loadJson

         pure $ codec.decoder json <#> (\input -> mkPageSpecWithInputBoxed
             { input
             , component: page.component
             , title: page.title
             })
      (StaticPageData input) ->
        pure $ Right $ mkPageSpecWithInputBoxed
          { input
          , component: page.component
          , title: page.title
          }
    )

module Nextjs.Pages.DynamicInput (page) where

import Nextjs.Lib.Api
import Nextjs.Lib.Page
import Protolude

import Affjax as Affjax
import Affjax.RequestBody (json) as Affjax.RequestBody
import Affjax.ResponseFormat (json) as Affjax.ResponseFormat
import Data.Argonaut as ArgonautCore
import Data.Argonaut.Encode (encodeJson) as ArgonautCodecs
import Example.DynamicInput.Container as Example.DynamicInput.Container
import Halogen as H
import Halogen.HTML as Halogen.HTML

requestGraphql :: String -> Aff (Either Affjax.Error (Affjax.Response ArgonautCore.Json))
requestGraphql query =
  Affjax.post
    Affjax.ResponseFormat.json
    graphqlUrl
    (Just $ Affjax.RequestBody.json $ ArgonautCodecs.encodeJson { query })

  where
    graphqlUrl = "https://graphql.anilist.co/"

type PageData =
  { data ::
    { "MediaTagCollection" :: Array
      { id :: Int
      , name :: String
      }
    }
  }

pageSpec :: PageSpec PageData
pageSpec =
  { pageData: DynamicPageData
    { codec: mkCodec
    , request: requestGraphql "query { MediaTagCollection { id name } }"
    }
  , component: H.hoist liftAff $ Example.DynamicInput.Container.component
  , title: "Halogen Example - DynamicInput"
  }

page :: Page
page = mkPage pageSpec

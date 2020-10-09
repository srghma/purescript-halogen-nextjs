module NextjsApp.Pages.Examples.DynamicInput (page) where

import Affjax as Affjax
import Affjax.RequestBody as Affjax.RequestBody
import Affjax.ResponseFormat as Affjax.ResponseFormat
import Data.Argonaut as ArgonautCore
import Data.Argonaut.Encode as ArgonautCodecs
import Example.DynamicInput.Container as Example.DynamicInput.Container
import Halogen as H
import Nextjs.Page (Page, PageData(..), PageSpec, mkCodec, mkPage)
import Protolude

requestGraphql :: String -> Aff (Either Affjax.Error (Affjax.Response ArgonautCore.Json))
requestGraphql query =
  Affjax.post
    Affjax.ResponseFormat.json
    graphqlUrl
    (Just $ Affjax.RequestBody.json $ ArgonautCodecs.encodeJson { query })
  where
  graphqlUrl = "https://graphql.anilist.co/"

type ThisPageData
  = { data ::
      { "MediaTagCollection" ::
        Array
          { id :: Int
          , name :: String
          }
      }
    }

pageSpec :: PageSpec ThisPageData
pageSpec =
  { pageData:
    DynamicPageData
      { codec: mkCodec
      , request: requestGraphql "query { MediaTagCollection { id name } }"
      }
  , component: H.hoist liftAff $ Example.DynamicInput.Container.component
  , title: "Halogen Example - DynamicInput"
  }

page :: Page
page = mkPage pageSpec

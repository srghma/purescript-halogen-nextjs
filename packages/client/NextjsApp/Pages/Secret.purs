module NextjsApp.Pages.Secret (page) where

import Protolude

import NextjsApp.Queries.Utils
import NextjsApp.PageImplementations.Secret.Types
import Nextjs.Page (Page, PageData(..), PageSpec, mkDynamicPageCodec, mkPage, DynamicPageCodec)
import NextjsApp.PageImplementations.Secret as NextjsApp.PageImplementations.Secret
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User

pageSpec :: PageSpec SecretPageUserData
pageSpec =
  { pageData: DynamicPageData
    { codec: (mkDynamicPageCodec :: DynamicPageCodec SecretPageUserData)
    -- | , request :: Aff (Either Affjax.Error (Affjax.Response ArgonautCore.Json))
    , request: do
        resp <- graphqlApiQueryRequestOrThrow $
          NextjsGraphqlApi.Query.currentUser
          ( ado
              id <- NextjsGraphqlApi.Object.User.id <#> unwrap
              name <- NextjsGraphqlApi.Object.User.name
              username <- NextjsGraphqlApi.Object.User.username
            in SecretPageUserData { id, name, username }
          )

        traceM resp

        pure $ Right undefined
    }
  , component: NextjsApp.PageImplementations.Secret.component
  , title: "Secret"
  }

page :: Page
page = mkPage pageSpec

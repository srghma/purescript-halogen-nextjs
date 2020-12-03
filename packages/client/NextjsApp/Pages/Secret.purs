module NextjsApp.Pages.Secret (page) where

import Protolude

import NextjsApp.Queries.Utils
import NextjsApp.PageImplementations.Secret.Types
import Nextjs.Page
import NextjsApp.PageImplementations.Secret as NextjsApp.PageImplementations.Secret
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User

pageSpec :: PageSpec SecretPageUserData
pageSpec =
  { pageData: PageData__Dynamic undefined
    -- | ( NextjsGraphqlApi.Query.currentUser
    -- |   ( ado
    -- |       id <- NextjsGraphqlApi.Object.User.id <#> unwrap
    -- |       name <- NextjsGraphqlApi.Object.User.name
    -- |       username <- NextjsGraphqlApi.Object.User.username
    -- |     in SecretPageUserData { id, name, username }
    -- |   )
    -- | )
  , component: NextjsApp.PageImplementations.Secret.component
  , title: "Secret"
  }

page :: Page
page = mkPage pageSpec

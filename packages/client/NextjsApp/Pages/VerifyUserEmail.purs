module NextjsApp.Pages.VerifyUserEmail (page) where

import Protolude

import NextjsApp.Queries.Utils
import NextjsApp.PageImplementations.VerifyUserEmail.Types
import Nextjs.Page
import NextjsApp.PageImplementations.VerifyUserEmail as NextjsApp.PageImplementations.VerifyUserEmail
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet(..))
import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.VerifyUserEmail.component
  , title: "Verify User Email"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

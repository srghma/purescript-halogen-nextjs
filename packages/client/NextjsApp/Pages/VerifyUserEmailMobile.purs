module NextjsApp.Pages.VerifyUserEmailMobile (page) where

import Protolude

import NextjsApp.Queries.Utils
import NextjsApp.PageImplementations.VerifyUserEmailMobile.Types
import Nextjs.Page
import NextjsApp.PageImplementations.VerifyUserEmailMobile as NextjsApp.PageImplementations.VerifyUserEmailMobile
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet(..))
import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.VerifyUserEmailMobile.component
  , title: "Verify User Email"
  }

page :: PageSpecBoxed
page = mkPageSpecBoxed pageSpec

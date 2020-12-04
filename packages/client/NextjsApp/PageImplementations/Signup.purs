module NextjsApp.PageImplementations.Signup (component) where

import NextjsGraphqlApi.Scalars
import Material.Classes.LayoutGrid
import NextjsApp.PageImplementations.Signup.Form
import NextjsApp.PageImplementations.Signup.Render
import NextjsApp.PageImplementations.Signup.Types
import Protolude

import Affjax as Affjax
import NextjsGraphqlApi.InputObject as NextjsGraphqlApi.InputObject
import NextjsGraphqlApi.Mutation as NextjsGraphqlApi.Mutation
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import Browser.Cookie as Browser.Cookie
import Data.Argonaut.Decode as Data.Argonaut.Decode
import Data.Array as Array
import Data.Array.NonEmpty as NonEmptyArray
import Data.Either (Either(..))
import Data.Email (Email)
import Data.Email as Email
import Data.Int as Int
import Data.Lens.Record as Lens
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Variant (Variant, inj)
import Formless as F
import GraphQLClient (GraphQLError, Scope__RootMutation, SelectionSet(..))
import GraphQLClient as GraphQLClient
import Halogen as H
import Halogen.Component as Halogen.Component
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Data.Password (Password)
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Data.NonUsedUsernameOrEmail (NonUsedUsernameOrEmail)
import NextjsApp.Data.NonUsedUsernameOrEmail as NextjsApp.Data.NonUsedUsernameOrEmail
import NextjsApp.Route as NextjsApp.Route
import ApiServerExceptions.PostgraphilePassportSignupPlugin as ApiServerExceptions.PostgraphilePassportSignupPlugin
import NextjsApp.Queries.Utils
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Object.WebSignupPayload as NextjsGraphqlApi.Object.WebSignupPayload
import NextjsGraphqlApi.Scalars as NextjsGraphqlApi.Scalars

component ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  H.Component Query Input Message m
component =
  H.mkComponent
    { initialState: const { signupError: Nothing }
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction =
              case _ of
                    Action__HandleSignupForm signupDataValidated -> do
                      traceM { signupDataValidated }

                      (response :: Either (GraphQLError Boolean) Boolean) <- liftAff do
                          let (query :: SelectionSet Scope__RootMutation (Maybe NextjsGraphqlApi.Scalars.Id)) =
                                  NextjsGraphqlApi.Mutation.webSignup
                                    { input: NextjsGraphqlApi.InputObject.WebSignupInput
                                      { username: NextjsApp.Data.NonUsedUsernameOrEmail.toString signupDataValidated.usernameOrEmail
                                      , password: NextjsApp.Data.Password.toString signupDataValidated.password
                                      }
                                    }
                                    (NextjsGraphqlApi.Object.WebSignupPayload.user NextjsGraphqlApi.Object.User.id)

                              (query' :: SelectionSet Scope__RootMutation Boolean) = query <#> Maybe.isJust

                          graphqlApiMutationRequest query'

                      let (response' :: Maybe SignupError) =
                              case response of
                                  Left error -> Just $
                                    case error of
                                          GraphQLClient.GraphQLError__Affjax affjaxError -> SignupError__UnknownError $ Affjax.printError affjaxError
                                          GraphQLClient.GraphQLError__UnexpectedPayload decodeError _jsonBody -> SignupError__UnknownError $ Data.Argonaut.Decode.printJsonDecodeError decodeError
                                          GraphQLClient.GraphQLError__User details _possiblyParsedData ->
                                            maybe
                                            (SignupError__UnknownError "unknown error")
                                            (case _ of
                                                  ApiServerExceptions.PostgraphilePassportSignupPlugin.WebSignupExceptionsClient__Internal -> SignupError__UnknownError "internal error"
                                                  ApiServerExceptions.PostgraphilePassportSignupPlugin.WebSignupExceptionsClient__SignupFailed -> SignupError__SignupFailed
                                            )
                                            $ ApiServerExceptions.PostgraphilePassportSignupPlugin.webSignupExceptionsClientFromString
                                            $ _.message
                                            $ unwrap
                                            $ NonEmptyArray.head details
                                  Right u -> Nothing

                      case response' of
                          Just error -> H.modify_ _ { signupError = Just error }
                          Nothing -> NextjsApp.Navigate.navigate NextjsApp.Route.Secret
            }
    }

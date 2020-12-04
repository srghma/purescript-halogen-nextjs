module NextjsApp.PageImplementations.Register (component) where

import NextjsGraphqlApi.Scalars
import Material.Classes.LayoutGrid
import NextjsApp.PageImplementations.Register.Form
import NextjsApp.PageImplementations.Register.Render
import NextjsApp.PageImplementations.Register.Types
import Protolude

import Affjax                                                 as Affjax
import NextjsGraphqlApi.InputObject                           as NextjsGraphqlApi.InputObject
import NextjsGraphqlApi.Mutation                              as NextjsGraphqlApi.Mutation
import NextjsGraphqlApi.Object.User                           as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query                                 as NextjsGraphqlApi.Query
import Browser.Cookie                                         as Browser.Cookie
import Data.Argonaut.Decode                                   as Data.Argonaut.Decode
import Data.Array                                             as Array
import Data.Array.NonEmpty                                    as NonEmptyArray
import Data.Either                                            (Either(..))
import Data.Email                                             (Email)
import Data.Email                                             as Email
import Data.Int                                               as Int
import Data.Lens.Record                                       as Lens
import Data.Maybe                                             (Maybe(..))
import Data.Maybe                                             as Maybe
import Data.String.NonEmpty                                   (NonEmptyString)
import Data.String.NonEmpty                                   as NonEmptyString
import Data.Variant                                           (Variant, inj)
import Formless                                               as F
import GraphQLClient                                          (GraphQLError, Scope__RootMutation, SelectionSet(..))
import GraphQLClient                                          as GraphQLClient
import Halogen                                                as H
import Halogen.Component                                      as Halogen.Component
import Halogen.HTML                                           as HH
import Halogen.HTML.Properties                                as HP
import HalogenMWC.Button                                      as Button
import HalogenMWC.TextField.Outlined                          as TextField.Outlined
import HalogenMWC.Utils                                       (setEfficiently)
import NextjsApp.AppM                                         (AppM)
import NextjsApp.Blocks.PurescriptLogo                        (purescriptLogoSrc)
import NextjsApp.Data.Password                                (Password)
import NextjsApp.Data.Password                                as NextjsApp.Data.Password
import NextjsApp.Navigate                                     as NextjsApp.Navigate
import NextjsApp.NodeEnv                                      as NextjsApp.NodeEnv
import NextjsApp.Data.NonUsedUsernameOrEmail                  (NonUsedUsernameOrEmail)
import NextjsApp.Data.NonUsedUsernameOrEmail                  as NextjsApp.Data.NonUsedUsernameOrEmail
import NextjsApp.Route                                        as NextjsApp.Route
import ApiServerExceptions.PostgraphilePassportAuthPlugin as ApiServerExceptions.PostgraphilePassportAuthPlugin
import NextjsApp.Queries.Utils
import NextjsGraphqlApi.Object.User                           as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Object.WebRegisterPayload             as NextjsGraphqlApi.Object.WebRegisterPayload
import NextjsGraphqlApi.Scalars                               as NextjsGraphqlApi.Scalars

component ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  H.Component Query Input Message m
component =
  H.mkComponent
    { initialState: const { registerError: Nothing }
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction =
              case _ of
                    Action__HandleRegisterForm registerDataValidated -> do
                      traceM { registerDataValidated }

                      (response :: Either (GraphQLError Boolean) Boolean) <- liftAff do
                          let (query :: SelectionSet Scope__RootMutation (Maybe NextjsGraphqlApi.Scalars.Id)) =
                                  NextjsGraphqlApi.Mutation.webRegister
                                    { input: NextjsGraphqlApi.InputObject.WebRegisterInput
                                      { username: NextjsApp.Data.NonUsedUsernameOrEmail.toString registerDataValidated.usernameOrEmail
                                      , password: NextjsApp.Data.Password.toString registerDataValidated.password
                                      }
                                    }
                                    (NextjsGraphqlApi.Object.WebRegisterPayload.user NextjsGraphqlApi.Object.User.id)

                              (query' :: SelectionSet Scope__RootMutation Boolean) = query <#> Maybe.isJust

                          graphqlApiMutationRequest query'

                      let (response' :: Maybe RegisterError) =
                              case response of
                                  Left error -> Just $
                                    case error of
                                          GraphQLClient.GraphQLError__Affjax affjaxError -> RegisterError__UnknownError $ Affjax.printError affjaxError
                                          GraphQLClient.GraphQLError__UnexpectedPayload decodeError _jsonBody -> RegisterError__UnknownError $ Data.Argonaut.Decode.printJsonDecodeError decodeError
                                          GraphQLClient.GraphQLError__User details _possiblyParsedData ->
                                            maybe
                                            (RegisterError__UnknownError "unknown error")
                                            (case _ of
                                                  ApiServerExceptions.PostgraphilePassportAuthPlugin.WebRegisterExceptionsClient__Internal -> RegisterError__UnknownError "internal error"
                                                  ApiServerExceptions.PostgraphilePassportAuthPlugin.WebRegisterExceptionsClient__RegisterFailed -> RegisterError__RegisterFailed
                                            )
                                            $ ApiServerExceptions.PostgraphilePassportAuthPlugin.webRegisterExceptionsClientFromString
                                            $ _.message
                                            $ unwrap
                                            $ NonEmptyArray.head details
                                  Right u -> Nothing

                      case response' of
                          Just error -> H.modify_ _ { registerError = Just error }
                          Nothing -> NextjsApp.Navigate.navigate NextjsApp.Route.Secret
            }
    }

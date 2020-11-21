module NextjsApp.PageImplementations.Login (component) where

import NextjsGraphqlApi.Scalars
import Material.Classes.LayoutGrid
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.PageImplementations.Login.Render
import NextjsApp.PageImplementations.Login.Types
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
import NextjsApp.Data.InUseUsernameOrEmail (InUseUsernameOrEmail)
import NextjsApp.Data.InUseUsernameOrEmail as NextjsApp.Data.InUseUsernameOrEmail
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.ServerExceptions as NextjsApp.ServerExceptions
import NextjsApp.Queries.Utils
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Object.WebLoginPayload as NextjsGraphqlApi.Object.WebLoginPayload
import NextjsGraphqlApi.Scalars as NextjsGraphqlApi.Scalars

component ::
  forall m r.
  MonadAsk { navigate :: NextjsApp.Route.Route -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  H.Component Query Input Message m
component =
  H.mkComponent
    { initialState: const initialState
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction =
              case _ of
                    Action__HandleLoginForm loginDataValidated -> do
                      traceM { loginDataValidated }

                      liftAff do
                         -- | let (query :: SelectionSet Scope__RootMutation (Maybe NextjsGraphqlApi.Scalars.Id)) =
                         -- |         NextjsGraphqlApi.Mutation.webLogin
                         -- |           { input: NextjsGraphqlApi.InputObject.WebLoginInput
                         -- |             { username: NextjsApp.Data.InUseUsernameOrEmail.toString loginDataValidated.usernameOrEmail
                         -- |             , password: NextjsApp.Data.Password.toString loginDataValidated.password
                         -- |             }
                         -- |           }
                         -- |           (NextjsGraphqlApi.Object.WebLoginPayload.user NextjsGraphqlApi.Object.User.id)

                         -- |     (query' :: SelectionSet Scope__RootMutation Boolean) = query <#> Maybe.isJust

                         -- | (response :: Either (GraphQLError Boolean) Boolean) <- graphqlApiMutationRequest query'

                         -- | let (response' :: Maybe LoginError) =
                         -- |       case spy "response" response of
                         -- |           Left error -> Just $
                         -- |             case error of
                         -- |                  GraphQLClient.GraphQLError__Affjax affjaxError -> LoginError__UnknownError $ Affjax.printError affjaxError
                         -- |                  GraphQLClient.GraphQLError__UnexpectedPayload decodeError _jsonBody -> LoginError__UnknownError $ Data.Argonaut.Decode.printJsonDecodeError decodeError
                         -- |                  GraphQLClient.GraphQLError__User details _possiblyParsedData ->
                         -- |                    let message = NonEmptyArray.head details # unwrap # _.message
                         -- |                     in LoginError__UnknownError message

                         -- |                     -- | in case unit of
                         -- |                     -- |         _ | message == NextjsApp.ServerExceptions.login_emailNotRegistered -> LoginError__EmailNotRegistered
                         -- |                     -- |           | message == NextjsApp.ServerExceptions.login_notConfirmed ->       LoginError__NotConfirmed
                         -- |                     -- |           | message == NextjsApp.ServerExceptions.login_wrongPassword ->      LoginError__WrongPassword
                         -- |                     -- |           | otherwise ->                                                      LoginError__UnknownError message
                         -- |           Right u -> Nothing

                         pure unit
                        -- | case _ of
                        -- |     Left error -> H.modify_ _ { loginError = Just error }
                        -- |     Right jwt ->
                        -- |       NextjsApp.Navigate.navigate NextjsApp.Route.Secret
            }
    , render
    }
  where
    initialState :: State
    initialState = { loginError: Nothing }

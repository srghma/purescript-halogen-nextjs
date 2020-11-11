module NextjsApp.PageImplementations.Login (component) where

import Api.Scalars
import Material.Classes.LayoutGrid
import NextjsApp.PageImplementations.Login.Form
import NextjsApp.PageImplementations.Login.Render
import NextjsApp.PageImplementations.Login.Types
import Protolude

import Affjax as Affjax
import Api.InputObject as Api.InputObject
import Api.Mutation as Api.Mutation
import Api.Object.User as Api.Object.User
import Api.Query as Api.Query
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
import NextjsApp.Queries.IsUsernameOrEmailTaken (NonTakenUsernameOrEmail)
import NextjsApp.Queries.IsUsernameOrEmailTaken as NextjsApp.Queries.IsUsernameOrEmailTaken
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.ServerExceptions as NextjsApp.ServerExceptions

login :: { usernameOrEmail :: NonTakenUsernameOrEmail, password :: Password } -> Aff (Maybe LoginError)
login loginDataValidated = do
  let (query :: SelectionSet Scope__RootMutation Boolean) =
        Api.Mutation.webLogin
          { input: Api.InputObject.WebLoginInput
            { username: NextjsApp.Queries.IsUsernameOrEmailTaken.toString loginDataValidated.usernameOrEmail
            , password: NextjsApp.Data.Password.toString loginDataValidated.password
            }
          }
          (pure unit)
        <#> Maybe.isJust

  (response :: Either (GraphQLError Boolean) Boolean) <-
      GraphQLClient.graphqlMutationRequest
      NextjsApp.NodeEnv.env.apiUrl
      GraphQLClient.defaultRequestOptions
      query

  let (response' :: Maybe LoginError) =
        case response of
            Left error -> Just $
              case error of
                   GraphQLClient.GraphQLError__Affjax affjaxError -> LoginError__UnknownError $ Affjax.printError affjaxError
                   GraphQLClient.GraphQLError__UnexpectedPayload decodeError _jsonBody -> LoginError__UnknownError $ Data.Argonaut.Decode.printJsonDecodeError decodeError
                   GraphQLClient.GraphQLError__User details _possiblyParsedData ->
                     let message = NonEmptyArray.head details # unwrap # _.message
                      in LoginError__UnknownError message

                      -- | in case unit of
                      -- |         _ | message == NextjsApp.ServerExceptions.login_emailNotRegistered -> LoginError__EmailNotRegistered
                      -- |           | message == NextjsApp.ServerExceptions.login_notConfirmed ->       LoginError__NotConfirmed
                      -- |           | message == NextjsApp.ServerExceptions.login_wrongPassword ->      LoginError__WrongPassword
                      -- |           | otherwise ->                                                      LoginError__UnknownError message
            Right u -> Nothing

  pure response'

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
                      traceM loginDataValidated

                      void $ liftAff (login loginDataValidated)
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

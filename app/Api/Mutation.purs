module Api.Mutation where

import Api.InputObject
  ( CreateUserEmailInput
  , DeleteUserInput
  , DeleteUserAuthenticationInput
  , DeleteUserAuthenticationByIdInput
  , DeleteUserAuthenticationByServiceAndIdentifierInput
  , DeleteUserByIdInput
  , DeleteUserByUsernameInput
  , DeleteUserEmailInput
  , DeleteUserEmailByIdInput
  , DeleteUserEmailByUserIdAndEmailInput
  , ForgotPasswordInput
  , ResetPasswordInput
  , UpdateUserInput
  , UpdateUserByIdInput
  , UpdateUserByUsernameInput
  , UpsertUserEmailInput
  , VerifyUserEmailInput
  , WebLoginInput
  , WebRegisterInput
  ) as Api.InputObject
import Type.Row (type (+))
import GraphQLClient
  ( SelectionSet
  , Scope__RootMutation
  , selectionForCompositeField
  , toGraphQLArguments
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import Api.Scopes
  ( Scope__CreateUserEmailPayload
  , Scope__DeleteUserPayload
  , Scope__DeleteUserAuthenticationPayload
  , Scope__DeleteUserEmailPayload
  , Scope__ForgotPasswordPayload
  , Scope__ResetPasswordPayload
  , Scope__UpdateUserPayload
  , Scope__UpsertUserEmailPayload
  , Scope__VerifyUserEmailPayload
  , Scope__WebLoginPayload
  , Scope__WebRegisterPayload
  )
import Data.Maybe (Maybe)

type CreateUserEmailInputRowRequired r = ( input :: Api.InputObject.CreateUserEmailInput
                                         | r
                                         )

type CreateUserEmailInput = { | CreateUserEmailInputRowRequired + () }

createUserEmail :: forall r . CreateUserEmailInput -> SelectionSet
                                                      Scope__CreateUserEmailPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
createUserEmail input = selectionForCompositeField
                        "createUserEmail"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserInputRowRequired r = ( input :: Api.InputObject.DeleteUserInput
                                    | r
                                    )

type DeleteUserInput = { | DeleteUserInputRowRequired + () }

deleteUser :: forall r . DeleteUserInput -> SelectionSet
                                            Scope__DeleteUserPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
deleteUser input = selectionForCompositeField
                   "deleteUser"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserAuthenticationInputRowRequired r = ( input :: Api.InputObject.DeleteUserAuthenticationInput
                                                  | r
                                                  )

type DeleteUserAuthenticationInput = {
| DeleteUserAuthenticationInputRowRequired + ()
}

deleteUserAuthentication :: forall r . DeleteUserAuthenticationInput -> SelectionSet
                                                                        Scope__DeleteUserAuthenticationPayload
                                                                        r -> SelectionSet
                                                                             Scope__RootMutation
                                                                             (Maybe
                                                                              r)
deleteUserAuthentication input = selectionForCompositeField
                                 "deleteUserAuthentication"
                                 (toGraphQLArguments
                                  input)
                                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserAuthenticationByIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserAuthenticationByIdInput
                                                      | r
                                                      )

type DeleteUserAuthenticationByIdInput = {
| DeleteUserAuthenticationByIdInputRowRequired + ()
}

deleteUserAuthenticationById :: forall r . DeleteUserAuthenticationByIdInput -> SelectionSet
                                                                                Scope__DeleteUserAuthenticationPayload
                                                                                r -> SelectionSet
                                                                                     Scope__RootMutation
                                                                                     (Maybe
                                                                                      r)
deleteUserAuthenticationById input = selectionForCompositeField
                                     "deleteUserAuthenticationById"
                                     (toGraphQLArguments
                                      input)
                                     graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserAuthenticationByServiceAndIdentifierInputRowRequired r = ( input :: Api.InputObject.DeleteUserAuthenticationByServiceAndIdentifierInput
                                                                        | r
                                                                        )

type DeleteUserAuthenticationByServiceAndIdentifierInput = {
| DeleteUserAuthenticationByServiceAndIdentifierInputRowRequired + ()
}

deleteUserAuthenticationByServiceAndIdentifier :: forall r . DeleteUserAuthenticationByServiceAndIdentifierInput -> SelectionSet
                                                                                                                    Scope__DeleteUserAuthenticationPayload
                                                                                                                    r -> SelectionSet
                                                                                                                         Scope__RootMutation
                                                                                                                         (Maybe
                                                                                                                          r)
deleteUserAuthenticationByServiceAndIdentifier input = selectionForCompositeField
                                                       "deleteUserAuthenticationByServiceAndIdentifier"
                                                       (toGraphQLArguments
                                                        input)
                                                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserByIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserByIdInput
                                        | r
                                        )

type DeleteUserByIdInput = { | DeleteUserByIdInputRowRequired + () }

deleteUserById :: forall r . DeleteUserByIdInput -> SelectionSet
                                                    Scope__DeleteUserPayload
                                                    r -> SelectionSet
                                                         Scope__RootMutation
                                                         (Maybe
                                                          r)
deleteUserById input = selectionForCompositeField
                       "deleteUserById"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserByUsernameInputRowRequired r = ( input :: Api.InputObject.DeleteUserByUsernameInput
                                              | r
                                              )

type DeleteUserByUsernameInput = { | DeleteUserByUsernameInputRowRequired + () }

deleteUserByUsername :: forall r . DeleteUserByUsernameInput -> SelectionSet
                                                                Scope__DeleteUserPayload
                                                                r -> SelectionSet
                                                                     Scope__RootMutation
                                                                     (Maybe
                                                                      r)
deleteUserByUsername input = selectionForCompositeField
                             "deleteUserByUsername"
                             (toGraphQLArguments
                              input)
                             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserEmailInputRowRequired r = ( input :: Api.InputObject.DeleteUserEmailInput
                                         | r
                                         )

type DeleteUserEmailInput = { | DeleteUserEmailInputRowRequired + () }

deleteUserEmail :: forall r . DeleteUserEmailInput -> SelectionSet
                                                      Scope__DeleteUserEmailPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
deleteUserEmail input = selectionForCompositeField
                        "deleteUserEmail"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserEmailByIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserEmailByIdInput
                                             | r
                                             )

type DeleteUserEmailByIdInput = { | DeleteUserEmailByIdInputRowRequired + () }

deleteUserEmailById :: forall r . DeleteUserEmailByIdInput -> SelectionSet
                                                              Scope__DeleteUserEmailPayload
                                                              r -> SelectionSet
                                                                   Scope__RootMutation
                                                                   (Maybe
                                                                    r)
deleteUserEmailById input = selectionForCompositeField
                            "deleteUserEmailById"
                            (toGraphQLArguments
                             input)
                            graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserEmailByUserIdAndEmailInputRowRequired r = ( input :: Api.InputObject.DeleteUserEmailByUserIdAndEmailInput
                                                         | r
                                                         )

type DeleteUserEmailByUserIdAndEmailInput = {
| DeleteUserEmailByUserIdAndEmailInputRowRequired + ()
}

deleteUserEmailByUserIdAndEmail :: forall r . DeleteUserEmailByUserIdAndEmailInput -> SelectionSet
                                                                                      Scope__DeleteUserEmailPayload
                                                                                      r -> SelectionSet
                                                                                           Scope__RootMutation
                                                                                           (Maybe
                                                                                            r)
deleteUserEmailByUserIdAndEmail input = selectionForCompositeField
                                        "deleteUserEmailByUserIdAndEmail"
                                        (toGraphQLArguments
                                         input)
                                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type ForgotPasswordInputRowRequired r = ( input :: Api.InputObject.ForgotPasswordInput
                                        | r
                                        )

type ForgotPasswordInput = { | ForgotPasswordInputRowRequired + () }

forgotPassword :: forall r . ForgotPasswordInput -> SelectionSet
                                                    Scope__ForgotPasswordPayload
                                                    r -> SelectionSet
                                                         Scope__RootMutation
                                                         (Maybe
                                                          r)
forgotPassword input = selectionForCompositeField
                       "forgotPassword"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type ResetPasswordInputRowRequired r = ( input :: Api.InputObject.ResetPasswordInput
                                       | r
                                       )

type ResetPasswordInput = { | ResetPasswordInputRowRequired + () }

resetPassword :: forall r . ResetPasswordInput -> SelectionSet
                                                  Scope__ResetPasswordPayload
                                                  r -> SelectionSet
                                                       Scope__RootMutation
                                                       (Maybe
                                                        r)
resetPassword input = selectionForCompositeField
                      "resetPassword"
                      (toGraphQLArguments
                       input)
                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserInputRowRequired r = ( input :: Api.InputObject.UpdateUserInput
                                    | r
                                    )

type UpdateUserInput = { | UpdateUserInputRowRequired + () }

updateUser :: forall r . UpdateUserInput -> SelectionSet
                                            Scope__UpdateUserPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
updateUser input = selectionForCompositeField
                   "updateUser"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserByIdInputRowRequired r = ( input :: Api.InputObject.UpdateUserByIdInput
                                        | r
                                        )

type UpdateUserByIdInput = { | UpdateUserByIdInputRowRequired + () }

updateUserById :: forall r . UpdateUserByIdInput -> SelectionSet
                                                    Scope__UpdateUserPayload
                                                    r -> SelectionSet
                                                         Scope__RootMutation
                                                         (Maybe
                                                          r)
updateUserById input = selectionForCompositeField
                       "updateUserById"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserByUsernameInputRowRequired r = ( input :: Api.InputObject.UpdateUserByUsernameInput
                                              | r
                                              )

type UpdateUserByUsernameInput = { | UpdateUserByUsernameInputRowRequired + () }

updateUserByUsername :: forall r . UpdateUserByUsernameInput -> SelectionSet
                                                                Scope__UpdateUserPayload
                                                                r -> SelectionSet
                                                                     Scope__RootMutation
                                                                     (Maybe
                                                                      r)
updateUserByUsername input = selectionForCompositeField
                             "updateUserByUsername"
                             (toGraphQLArguments
                              input)
                             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpsertUserEmailInputRowRequired r = ( input :: Api.InputObject.UpsertUserEmailInput
                                         | r
                                         )

type UpsertUserEmailInput = { | UpsertUserEmailInputRowRequired + () }

upsertUserEmail :: forall r . UpsertUserEmailInput -> SelectionSet
                                                      Scope__UpsertUserEmailPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
upsertUserEmail input = selectionForCompositeField
                        "upsertUserEmail"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type VerifyUserEmailInputRowRequired r = ( input :: Api.InputObject.VerifyUserEmailInput
                                         | r
                                         )

type VerifyUserEmailInput = { | VerifyUserEmailInputRowRequired + () }

verifyUserEmail :: forall r . VerifyUserEmailInput -> SelectionSet
                                                      Scope__VerifyUserEmailPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
verifyUserEmail input = selectionForCompositeField
                        "verifyUserEmail"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type WebLoginInputRowRequired r = ( input :: Api.InputObject.WebLoginInput | r )

type WebLoginInput = { | WebLoginInputRowRequired + () }

webLogin :: forall r . WebLoginInput -> SelectionSet
                                        Scope__WebLoginPayload
                                        r -> SelectionSet
                                             Scope__RootMutation
                                             (Maybe
                                              r)
webLogin input = selectionForCompositeField
                 "webLogin"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type WebRegisterInputRowRequired r = ( input :: Api.InputObject.WebRegisterInput
                                     | r
                                     )

type WebRegisterInput = { | WebRegisterInputRowRequired + () }

webRegister :: forall r . WebRegisterInput -> SelectionSet
                                              Scope__WebRegisterPayload
                                              r -> SelectionSet
                                                   Scope__RootMutation
                                                   (Maybe
                                                    r)
webRegister input = selectionForCompositeField
                    "webRegister"
                    (toGraphQLArguments
                     input)
                    graphqlDefaultResponseFunctorOrScalarDecoderTransformer

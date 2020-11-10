module Api.Mutation where

import Api.InputObject
  ( CreateUserEmailInput
  , DeleteUserInput
  , DeleteUserAuthenticationInput
  , DeleteUserAuthenticationByNodeIdInput
  , DeleteUserAuthenticationByServiceAndIdentifierInput
  , DeleteUserByNodeIdInput
  , DeleteUserByUsernameInput
  , DeleteUserEmailInput
  , DeleteUserEmailByNodeIdInput
  , DeleteUserEmailByUserIdAndEmailInput
  , ForgotPasswordInput
  , ResetPasswordInput
  , UpdateUserInput
  , UpdateUserByNodeIdInput
  , UpdateUserByUsernameInput
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

type DeleteUserAuthenticationByNodeIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserAuthenticationByNodeIdInput
                                                          | r
                                                          )

type DeleteUserAuthenticationByNodeIdInput = {
| DeleteUserAuthenticationByNodeIdInputRowRequired + ()
}

deleteUserAuthenticationByNodeId :: forall r . DeleteUserAuthenticationByNodeIdInput -> SelectionSet
                                                                                        Scope__DeleteUserAuthenticationPayload
                                                                                        r -> SelectionSet
                                                                                             Scope__RootMutation
                                                                                             (Maybe
                                                                                              r)
deleteUserAuthenticationByNodeId input = selectionForCompositeField
                                         "deleteUserAuthenticationByNodeId"
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

type DeleteUserByNodeIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserByNodeIdInput
                                            | r
                                            )

type DeleteUserByNodeIdInput = { | DeleteUserByNodeIdInputRowRequired + () }

deleteUserByNodeId :: forall r . DeleteUserByNodeIdInput -> SelectionSet
                                                            Scope__DeleteUserPayload
                                                            r -> SelectionSet
                                                                 Scope__RootMutation
                                                                 (Maybe
                                                                  r)
deleteUserByNodeId input = selectionForCompositeField
                           "deleteUserByNodeId"
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

type DeleteUserEmailByNodeIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserEmailByNodeIdInput
                                                 | r
                                                 )

type DeleteUserEmailByNodeIdInput = {
| DeleteUserEmailByNodeIdInputRowRequired + ()
}

deleteUserEmailByNodeId :: forall r . DeleteUserEmailByNodeIdInput -> SelectionSet
                                                                      Scope__DeleteUserEmailPayload
                                                                      r -> SelectionSet
                                                                           Scope__RootMutation
                                                                           (Maybe
                                                                            r)
deleteUserEmailByNodeId input = selectionForCompositeField
                                "deleteUserEmailByNodeId"
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

type UpdateUserByNodeIdInputRowRequired r = ( input :: Api.InputObject.UpdateUserByNodeIdInput
                                            | r
                                            )

type UpdateUserByNodeIdInput = { | UpdateUserByNodeIdInputRowRequired + () }

updateUserByNodeId :: forall r . UpdateUserByNodeIdInput -> SelectionSet
                                                            Scope__UpdateUserPayload
                                                            r -> SelectionSet
                                                                 Scope__RootMutation
                                                                 (Maybe
                                                                  r)
updateUserByNodeId input = selectionForCompositeField
                           "updateUserByNodeId"
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

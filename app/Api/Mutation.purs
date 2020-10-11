module Api.Mutation where

import Api.InputObject
  ( CreatePostInput
  , CreateUserOauthInput
  , CreateUserInput
  , UpdatePostInput
  , UpdatePostByRowIdInput
  , UpdateUserOauthInput
  , UpdateUserOauthByRowIdInput
  , UpdateUserOauthByServiceAndServiceIdentifierInput
  , UpdateUserInput
  , UpdateUserByRowIdInput
  , UpdateUserByEmailInput
  , DeletePostInput
  , DeletePostByRowIdInput
  , DeleteUserOauthInput
  , DeleteUserOauthByRowIdInput
  , DeleteUserOauthByServiceAndServiceIdentifierInput
  , DeleteUserInput
  , DeleteUserByRowIdInput
  , DeleteUserByEmailInput
  , ConfirmInput
  , LoginInput
  , RegisterInput
  , ResendConfirmationInput
  , ResetPasswordInput
  , SendResetPasswordInput
  , UpsertPostInput
  , UpsertUserOauthInput
  , UpsertUserInput
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
  ( Scope__CreatePostPayload
  , Scope__CreateUserOauthPayload
  , Scope__CreateUserPayload
  , Scope__UpdatePostPayload
  , Scope__UpdateUserOauthPayload
  , Scope__UpdateUserPayload
  , Scope__DeletePostPayload
  , Scope__DeleteUserOauthPayload
  , Scope__DeleteUserPayload
  , Scope__ConfirmPayload
  , Scope__LoginPayload
  , Scope__RegisterPayload
  , Scope__ResendConfirmationPayload
  , Scope__ResetPasswordPayload
  , Scope__SendResetPasswordPayload
  , Scope__UpsertPostPayload
  , Scope__UpsertUserOauthPayload
  , Scope__UpsertUserPayload
  )
import Data.Maybe (Maybe)

type CreatePostInputRowRequired r = ( input :: Api.InputObject.CreatePostInput
                                    | r
                                    )

type CreatePostInput = { | CreatePostInputRowRequired + () }

createPost :: forall r . CreatePostInput -> SelectionSet
                                            Scope__CreatePostPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
createPost input = selectionForCompositeField
                   "createPost"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type CreateUserOauthInputRowRequired r = ( input :: Api.InputObject.CreateUserOauthInput
                                         | r
                                         )

type CreateUserOauthInput = { | CreateUserOauthInputRowRequired + () }

createUserOauth :: forall r . CreateUserOauthInput -> SelectionSet
                                                      Scope__CreateUserOauthPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
createUserOauth input = selectionForCompositeField
                        "createUserOauth"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type CreateUserInputRowRequired r = ( input :: Api.InputObject.CreateUserInput
                                    | r
                                    )

type CreateUserInput = { | CreateUserInputRowRequired + () }

createUser :: forall r . CreateUserInput -> SelectionSet
                                            Scope__CreateUserPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
createUser input = selectionForCompositeField
                   "createUser"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdatePostInputRowRequired r = ( input :: Api.InputObject.UpdatePostInput
                                    | r
                                    )

type UpdatePostInput = { | UpdatePostInputRowRequired + () }

updatePost :: forall r . UpdatePostInput -> SelectionSet
                                            Scope__UpdatePostPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
updatePost input = selectionForCompositeField
                   "updatePost"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdatePostByRowIdInputRowRequired r = ( input :: Api.InputObject.UpdatePostByRowIdInput
                                           | r
                                           )

type UpdatePostByRowIdInput = { | UpdatePostByRowIdInputRowRequired + () }

updatePostByRowId :: forall r . UpdatePostByRowIdInput -> SelectionSet
                                                          Scope__UpdatePostPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
updatePostByRowId input = selectionForCompositeField
                          "updatePostByRowId"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserOauthInputRowRequired r = ( input :: Api.InputObject.UpdateUserOauthInput
                                         | r
                                         )

type UpdateUserOauthInput = { | UpdateUserOauthInputRowRequired + () }

updateUserOauth :: forall r . UpdateUserOauthInput -> SelectionSet
                                                      Scope__UpdateUserOauthPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
updateUserOauth input = selectionForCompositeField
                        "updateUserOauth"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserOauthByRowIdInputRowRequired r = ( input :: Api.InputObject.UpdateUserOauthByRowIdInput
                                                | r
                                                )

type UpdateUserOauthByRowIdInput = {
| UpdateUserOauthByRowIdInputRowRequired + ()
}

updateUserOauthByRowId :: forall r . UpdateUserOauthByRowIdInput -> SelectionSet
                                                                    Scope__UpdateUserOauthPayload
                                                                    r -> SelectionSet
                                                                         Scope__RootMutation
                                                                         (Maybe
                                                                          r)
updateUserOauthByRowId input = selectionForCompositeField
                               "updateUserOauthByRowId"
                               (toGraphQLArguments
                                input)
                               graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserOauthByServiceAndServiceIdentifierInputRowRequired r = ( input :: Api.InputObject.UpdateUserOauthByServiceAndServiceIdentifierInput
                                                                      | r
                                                                      )

type UpdateUserOauthByServiceAndServiceIdentifierInput = {
| UpdateUserOauthByServiceAndServiceIdentifierInputRowRequired + ()
}

updateUserOauthByServiceAndServiceIdentifier :: forall r . UpdateUserOauthByServiceAndServiceIdentifierInput -> SelectionSet
                                                                                                                Scope__UpdateUserOauthPayload
                                                                                                                r -> SelectionSet
                                                                                                                     Scope__RootMutation
                                                                                                                     (Maybe
                                                                                                                      r)
updateUserOauthByServiceAndServiceIdentifier input = selectionForCompositeField
                                                     "updateUserOauthByServiceAndServiceIdentifier"
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

type UpdateUserByRowIdInputRowRequired r = ( input :: Api.InputObject.UpdateUserByRowIdInput
                                           | r
                                           )

type UpdateUserByRowIdInput = { | UpdateUserByRowIdInputRowRequired + () }

updateUserByRowId :: forall r . UpdateUserByRowIdInput -> SelectionSet
                                                          Scope__UpdateUserPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
updateUserByRowId input = selectionForCompositeField
                          "updateUserByRowId"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserByEmailInputRowRequired r = ( input :: Api.InputObject.UpdateUserByEmailInput
                                           | r
                                           )

type UpdateUserByEmailInput = { | UpdateUserByEmailInputRowRequired + () }

updateUserByEmail :: forall r . UpdateUserByEmailInput -> SelectionSet
                                                          Scope__UpdateUserPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
updateUserByEmail input = selectionForCompositeField
                          "updateUserByEmail"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeletePostInputRowRequired r = ( input :: Api.InputObject.DeletePostInput
                                    | r
                                    )

type DeletePostInput = { | DeletePostInputRowRequired + () }

deletePost :: forall r . DeletePostInput -> SelectionSet
                                            Scope__DeletePostPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
deletePost input = selectionForCompositeField
                   "deletePost"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeletePostByRowIdInputRowRequired r = ( input :: Api.InputObject.DeletePostByRowIdInput
                                           | r
                                           )

type DeletePostByRowIdInput = { | DeletePostByRowIdInputRowRequired + () }

deletePostByRowId :: forall r . DeletePostByRowIdInput -> SelectionSet
                                                          Scope__DeletePostPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
deletePostByRowId input = selectionForCompositeField
                          "deletePostByRowId"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserOauthInputRowRequired r = ( input :: Api.InputObject.DeleteUserOauthInput
                                         | r
                                         )

type DeleteUserOauthInput = { | DeleteUserOauthInputRowRequired + () }

deleteUserOauth :: forall r . DeleteUserOauthInput -> SelectionSet
                                                      Scope__DeleteUserOauthPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
deleteUserOauth input = selectionForCompositeField
                        "deleteUserOauth"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserOauthByRowIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserOauthByRowIdInput
                                                | r
                                                )

type DeleteUserOauthByRowIdInput = {
| DeleteUserOauthByRowIdInputRowRequired + ()
}

deleteUserOauthByRowId :: forall r . DeleteUserOauthByRowIdInput -> SelectionSet
                                                                    Scope__DeleteUserOauthPayload
                                                                    r -> SelectionSet
                                                                         Scope__RootMutation
                                                                         (Maybe
                                                                          r)
deleteUserOauthByRowId input = selectionForCompositeField
                               "deleteUserOauthByRowId"
                               (toGraphQLArguments
                                input)
                               graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserOauthByServiceAndServiceIdentifierInputRowRequired r = ( input :: Api.InputObject.DeleteUserOauthByServiceAndServiceIdentifierInput
                                                                      | r
                                                                      )

type DeleteUserOauthByServiceAndServiceIdentifierInput = {
| DeleteUserOauthByServiceAndServiceIdentifierInputRowRequired + ()
}

deleteUserOauthByServiceAndServiceIdentifier :: forall r . DeleteUserOauthByServiceAndServiceIdentifierInput -> SelectionSet
                                                                                                                Scope__DeleteUserOauthPayload
                                                                                                                r -> SelectionSet
                                                                                                                     Scope__RootMutation
                                                                                                                     (Maybe
                                                                                                                      r)
deleteUserOauthByServiceAndServiceIdentifier input = selectionForCompositeField
                                                     "deleteUserOauthByServiceAndServiceIdentifier"
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

type DeleteUserByRowIdInputRowRequired r = ( input :: Api.InputObject.DeleteUserByRowIdInput
                                           | r
                                           )

type DeleteUserByRowIdInput = { | DeleteUserByRowIdInputRowRequired + () }

deleteUserByRowId :: forall r . DeleteUserByRowIdInput -> SelectionSet
                                                          Scope__DeleteUserPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
deleteUserByRowId input = selectionForCompositeField
                          "deleteUserByRowId"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserByEmailInputRowRequired r = ( input :: Api.InputObject.DeleteUserByEmailInput
                                           | r
                                           )

type DeleteUserByEmailInput = { | DeleteUserByEmailInputRowRequired + () }

deleteUserByEmail :: forall r . DeleteUserByEmailInput -> SelectionSet
                                                          Scope__DeleteUserPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
deleteUserByEmail input = selectionForCompositeField
                          "deleteUserByEmail"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type ConfirmInputRowRequired r = ( input :: Api.InputObject.ConfirmInput | r )

type ConfirmInput = { | ConfirmInputRowRequired + () }

confirm :: forall r . ConfirmInput -> SelectionSet
                                      Scope__ConfirmPayload
                                      r -> SelectionSet
                                           Scope__RootMutation
                                           (Maybe
                                            r)
confirm input = selectionForCompositeField
                "confirm"
                (toGraphQLArguments
                 input)
                graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type LoginInputRowRequired r = ( input :: Api.InputObject.LoginInput | r )

type LoginInput = { | LoginInputRowRequired + () }

login :: forall r . LoginInput -> SelectionSet
                                  Scope__LoginPayload
                                  r -> SelectionSet
                                       Scope__RootMutation
                                       (Maybe
                                        r)
login input = selectionForCompositeField
              "login"
              (toGraphQLArguments
               input)
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type RegisterInputRowRequired r = ( input :: Api.InputObject.RegisterInput | r )

type RegisterInput = { | RegisterInputRowRequired + () }

register :: forall r . RegisterInput -> SelectionSet
                                        Scope__RegisterPayload
                                        r -> SelectionSet
                                             Scope__RootMutation
                                             (Maybe
                                              r)
register input = selectionForCompositeField
                 "register"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type ResendConfirmationInputRowRequired r = ( input :: Api.InputObject.ResendConfirmationInput
                                            | r
                                            )

type ResendConfirmationInput = { | ResendConfirmationInputRowRequired + () }

resendConfirmation :: forall r . ResendConfirmationInput -> SelectionSet
                                                            Scope__ResendConfirmationPayload
                                                            r -> SelectionSet
                                                                 Scope__RootMutation
                                                                 (Maybe
                                                                  r)
resendConfirmation input = selectionForCompositeField
                           "resendConfirmation"
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

type SendResetPasswordInputRowRequired r = ( input :: Api.InputObject.SendResetPasswordInput
                                           | r
                                           )

type SendResetPasswordInput = { | SendResetPasswordInputRowRequired + () }

sendResetPassword :: forall r . SendResetPasswordInput -> SelectionSet
                                                          Scope__SendResetPasswordPayload
                                                          r -> SelectionSet
                                                               Scope__RootMutation
                                                               (Maybe
                                                                r)
sendResetPassword input = selectionForCompositeField
                          "sendResetPassword"
                          (toGraphQLArguments
                           input)
                          graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpsertPostInputRowRequired r = ( input :: Api.InputObject.UpsertPostInput
                                    | r
                                    )

type UpsertPostInput = { | UpsertPostInputRowRequired + () }

upsertPost :: forall r . UpsertPostInput -> SelectionSet
                                            Scope__UpsertPostPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
upsertPost input = selectionForCompositeField
                   "upsertPost"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpsertUserOauthInputRowRequired r = ( input :: Api.InputObject.UpsertUserOauthInput
                                         | r
                                         )

type UpsertUserOauthInput = { | UpsertUserOauthInputRowRequired + () }

upsertUserOauth :: forall r . UpsertUserOauthInput -> SelectionSet
                                                      Scope__UpsertUserOauthPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
upsertUserOauth input = selectionForCompositeField
                        "upsertUserOauth"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpsertUserInputRowRequired r = ( input :: Api.InputObject.UpsertUserInput
                                    | r
                                    )

type UpsertUserInput = { | UpsertUserInputRowRequired + () }

upsertUser :: forall r . UpsertUserInput -> SelectionSet
                                            Scope__UpsertUserPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
upsertUser input = selectionForCompositeField
                   "upsertUser"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

module Api.InputObject where

import GraphQLClient (Optional)
import Api.Scalars (Uuid, Datetime, Id)

-- | original name - PostCondition
type PostCondition = { rowId :: Optional Uuid
                     , name :: Optional String
                     , content :: Optional String
                     , userId :: Optional Uuid
                     , createdAt :: Optional Datetime
                     , updatedAt :: Optional Datetime
                     }

-- | original name - CreatePostInput
type CreatePostInput = { clientMutationId :: Optional String
                       , post :: PostInput
                       }

-- | original name - PostInput
type PostInput = { rowId :: Optional Uuid
                 , name :: String
                 , content :: Optional String
                 , userId :: Uuid
                 , createdAt :: Optional Datetime
                 , updatedAt :: Optional Datetime
                 }

-- | original name - CreateUserOauthInput
type CreateUserOauthInput = { clientMutationId :: Optional String
                            , userOauth :: UserOauthInput
                            }

-- | original name - UserOauthInput
type UserOauthInput = { rowId :: Optional Uuid
                      , service :: String
                      , serviceIdentifier :: String
                      , createdAt :: Optional Datetime
                      , updatedAt :: Optional Datetime
                      }

-- | original name - CreateUserInput
type CreateUserInput = { clientMutationId :: Optional String
                       , user :: UserInput
                       }

-- | original name - UserInput
type UserInput = { rowId :: Optional Uuid
                 , firstName :: String
                 , lastName :: String
                 , email :: String
                 , avatarUrl :: Optional String
                 , createdAt :: Optional Datetime
                 , updatedAt :: Optional Datetime
                 }

-- | original name - UpdatePostInput
type UpdatePostInput = { clientMutationId :: Optional String
                       , id :: Id
                       , postPatch :: PostPatch
                       }

-- | original name - PostPatch
type PostPatch = { rowId :: Optional Uuid
                 , name :: Optional String
                 , content :: Optional String
                 , userId :: Optional Uuid
                 , createdAt :: Optional Datetime
                 , updatedAt :: Optional Datetime
                 }

-- | original name - UpdatePostByRowIdInput
type UpdatePostByRowIdInput = { clientMutationId :: Optional String
                              , postPatch :: PostPatch
                              , rowId :: Uuid
                              }

-- | original name - UpdateUserOauthInput
type UpdateUserOauthInput = { clientMutationId :: Optional String
                            , id :: Id
                            , userOauthPatch :: UserOauthPatch
                            }

-- | original name - UserOauthPatch
type UserOauthPatch = { rowId :: Optional Uuid
                      , service :: Optional String
                      , serviceIdentifier :: Optional String
                      , createdAt :: Optional Datetime
                      , updatedAt :: Optional Datetime
                      }

-- | original name - UpdateUserOauthByRowIdInput
type UpdateUserOauthByRowIdInput = { clientMutationId :: Optional String
                                   , userOauthPatch :: UserOauthPatch
                                   , rowId :: Uuid
                                   }

-- | original name - UpdateUserOauthByServiceAndServiceIdentifierInput
type UpdateUserOauthByServiceAndServiceIdentifierInput = { clientMutationId :: Optional
                                                                               String
                                                         , userOauthPatch :: UserOauthPatch
                                                         , service :: String
                                                         , serviceIdentifier :: String
                                                         }

-- | original name - UpdateUserInput
type UpdateUserInput = { clientMutationId :: Optional String
                       , id :: Id
                       , userPatch :: UserPatch
                       }

-- | original name - UserPatch
type UserPatch = { rowId :: Optional Uuid
                 , firstName :: Optional String
                 , lastName :: Optional String
                 , email :: Optional String
                 , avatarUrl :: Optional String
                 , createdAt :: Optional Datetime
                 , updatedAt :: Optional Datetime
                 }

-- | original name - UpdateUserByRowIdInput
type UpdateUserByRowIdInput = { clientMutationId :: Optional String
                              , userPatch :: UserPatch
                              , rowId :: Uuid
                              }

-- | original name - UpdateUserByEmailInput
type UpdateUserByEmailInput = { clientMutationId :: Optional String
                              , userPatch :: UserPatch
                              , email :: String
                              }

-- | original name - DeletePostInput
type DeletePostInput = { clientMutationId :: Optional String, id :: Id }

-- | original name - DeletePostByRowIdInput
type DeletePostByRowIdInput = { clientMutationId :: Optional String
                              , rowId :: Uuid
                              }

-- | original name - DeleteUserOauthInput
type DeleteUserOauthInput = { clientMutationId :: Optional String, id :: Id }

-- | original name - DeleteUserOauthByRowIdInput
type DeleteUserOauthByRowIdInput = { clientMutationId :: Optional String
                                   , rowId :: Uuid
                                   }

-- | original name - DeleteUserOauthByServiceAndServiceIdentifierInput
type DeleteUserOauthByServiceAndServiceIdentifierInput = { clientMutationId :: Optional
                                                                               String
                                                         , service :: String
                                                         , serviceIdentifier :: String
                                                         }

-- | original name - DeleteUserInput
type DeleteUserInput = { clientMutationId :: Optional String, id :: Id }

-- | original name - DeleteUserByRowIdInput
type DeleteUserByRowIdInput = { clientMutationId :: Optional String
                              , rowId :: Uuid
                              }

-- | original name - DeleteUserByEmailInput
type DeleteUserByEmailInput = { clientMutationId :: Optional String
                              , email :: String
                              }

-- | original name - ConfirmInput
type ConfirmInput = { clientMutationId :: Optional String, token :: String }

-- | original name - LoginInput
type LoginInput = { clientMutationId :: Optional String
                  , email :: String
                  , password :: String
                  }

-- | original name - RegisterInput
type RegisterInput = { clientMutationId :: Optional String
                     , firstName :: String
                     , lastName :: String
                     , email :: String
                     , password :: String
                     }

-- | original name - ResendConfirmationInput
type ResendConfirmationInput = { clientMutationId :: Optional String
                               , email :: String
                               }

-- | original name - ResetPasswordInput
type ResetPasswordInput = { clientMutationId :: Optional String
                          , token :: String
                          , newPassword :: String
                          }

-- | original name - SendResetPasswordInput
type SendResetPasswordInput = { clientMutationId :: Optional String
                              , email :: String
                              }

-- | original name - UpsertPostInput
type UpsertPostInput = { clientMutationId :: Optional String
                       , post :: PostInput
                       }

-- | original name - UpsertUserOauthInput
type UpsertUserOauthInput = { clientMutationId :: Optional String
                            , userOauth :: UserOauthInput
                            }

-- | original name - UpsertUserInput
type UpsertUserInput = { clientMutationId :: Optional String
                       , user :: UserInput
                       }

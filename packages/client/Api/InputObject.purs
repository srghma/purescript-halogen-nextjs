module Api.InputObject where

import GraphQLClient
  (Optional, class ToGraphQLArgumentValue, toGraphQLArgumentValue)
import Api.Scalars (Uuid, Id)
import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)

-- | original name - PostCondition
newtype PostCondition = PostCondition { rowId :: Optional Uuid
                                      , userId :: Optional Uuid
                                      }

derive instance genericPostCondition :: Generic PostCondition _

derive instance newtypePostCondition :: Newtype PostCondition _

instance toGraphQLArgumentValuePostCondition :: ToGraphQLArgumentValue
                                                PostCondition where
  toGraphQLArgumentValue (PostCondition x) = toGraphQLArgumentValue x

-- | original name - UserEmailCondition
newtype UserEmailCondition = UserEmailCondition { rowId :: Optional Uuid
                                                , userId :: Optional Uuid
                                                }

derive instance genericUserEmailCondition :: Generic UserEmailCondition _

derive instance newtypeUserEmailCondition :: Newtype UserEmailCondition _

instance toGraphQLArgumentValueUserEmailCondition :: ToGraphQLArgumentValue
                                                     UserEmailCondition where
  toGraphQLArgumentValue (UserEmailCondition x) = toGraphQLArgumentValue x

-- | original name - CreateUserEmailInput
newtype CreateUserEmailInput = CreateUserEmailInput { clientMutationId :: Optional
                                                                          String
                                                    , userEmail :: UserEmailInput
                                                    }

derive instance genericCreateUserEmailInput :: Generic CreateUserEmailInput _

derive instance newtypeCreateUserEmailInput :: Newtype CreateUserEmailInput _

instance toGraphQLArgumentValueCreateUserEmailInput :: ToGraphQLArgumentValue
                                                       CreateUserEmailInput where
  toGraphQLArgumentValue (CreateUserEmailInput x) = toGraphQLArgumentValue x

-- | original name - UserEmailInput
newtype UserEmailInput = UserEmailInput { email :: String }

derive instance genericUserEmailInput :: Generic UserEmailInput _

derive instance newtypeUserEmailInput :: Newtype UserEmailInput _

instance toGraphQLArgumentValueUserEmailInput :: ToGraphQLArgumentValue
                                                 UserEmailInput where
  toGraphQLArgumentValue (UserEmailInput x) = toGraphQLArgumentValue x

-- | original name - DeleteUserInput
newtype DeleteUserInput = DeleteUserInput { clientMutationId :: Optional String
                                          , rowId :: Uuid
                                          }

derive instance genericDeleteUserInput :: Generic DeleteUserInput _

derive instance newtypeDeleteUserInput :: Newtype DeleteUserInput _

instance toGraphQLArgumentValueDeleteUserInput :: ToGraphQLArgumentValue
                                                  DeleteUserInput where
  toGraphQLArgumentValue (DeleteUserInput x) = toGraphQLArgumentValue x

-- | original name - DeleteUserAuthenticationInput
newtype DeleteUserAuthenticationInput = DeleteUserAuthenticationInput { clientMutationId :: Optional
                                                                                            String
                                                                      , rowId :: Uuid
                                                                      }

derive instance genericDeleteUserAuthenticationInput :: Generic DeleteUserAuthenticationInput _

derive instance newtypeDeleteUserAuthenticationInput :: Newtype DeleteUserAuthenticationInput _

instance toGraphQLArgumentValueDeleteUserAuthenticationInput :: ToGraphQLArgumentValue
                                                                DeleteUserAuthenticationInput where
  toGraphQLArgumentValue (DeleteUserAuthenticationInput x) = toGraphQLArgumentValue
                                                             x

-- | original name - DeleteUserAuthenticationByIdInput
newtype DeleteUserAuthenticationByIdInput = DeleteUserAuthenticationByIdInput { clientMutationId :: Optional
                                                                                                    String
                                                                              , id :: Id
                                                                              }

derive instance genericDeleteUserAuthenticationByIdInput :: Generic DeleteUserAuthenticationByIdInput _

derive instance newtypeDeleteUserAuthenticationByIdInput :: Newtype DeleteUserAuthenticationByIdInput _

instance toGraphQLArgumentValueDeleteUserAuthenticationByIdInput :: ToGraphQLArgumentValue
                                                                    DeleteUserAuthenticationByIdInput where
  toGraphQLArgumentValue (DeleteUserAuthenticationByIdInput x) = toGraphQLArgumentValue
                                                                 x

-- | original name - DeleteUserAuthenticationByServiceAndIdentifierInput
newtype DeleteUserAuthenticationByServiceAndIdentifierInput = DeleteUserAuthenticationByServiceAndIdentifierInput { clientMutationId :: Optional
                                                                                                                                        String
                                                                                                                  , identifier :: String
                                                                                                                  , service :: String
                                                                                                                  }

derive instance genericDeleteUserAuthenticationByServiceAndIdentifierInput :: Generic DeleteUserAuthenticationByServiceAndIdentifierInput _

derive instance newtypeDeleteUserAuthenticationByServiceAndIdentifierInput :: Newtype DeleteUserAuthenticationByServiceAndIdentifierInput _

instance toGraphQLArgumentValueDeleteUserAuthenticationByServiceAndIdentifierInput :: ToGraphQLArgumentValue
                                                                                      DeleteUserAuthenticationByServiceAndIdentifierInput where
  toGraphQLArgumentValue (DeleteUserAuthenticationByServiceAndIdentifierInput x) = toGraphQLArgumentValue
                                                                                   x

-- | original name - DeleteUserByIdInput
newtype DeleteUserByIdInput = DeleteUserByIdInput { clientMutationId :: Optional
                                                                        String
                                                  , id :: Id
                                                  }

derive instance genericDeleteUserByIdInput :: Generic DeleteUserByIdInput _

derive instance newtypeDeleteUserByIdInput :: Newtype DeleteUserByIdInput _

instance toGraphQLArgumentValueDeleteUserByIdInput :: ToGraphQLArgumentValue
                                                      DeleteUserByIdInput where
  toGraphQLArgumentValue (DeleteUserByIdInput x) = toGraphQLArgumentValue x

-- | original name - DeleteUserByUsernameInput
newtype DeleteUserByUsernameInput = DeleteUserByUsernameInput { clientMutationId :: Optional
                                                                                    String
                                                              , username :: String
                                                              }

derive instance genericDeleteUserByUsernameInput :: Generic DeleteUserByUsernameInput _

derive instance newtypeDeleteUserByUsernameInput :: Newtype DeleteUserByUsernameInput _

instance toGraphQLArgumentValueDeleteUserByUsernameInput :: ToGraphQLArgumentValue
                                                            DeleteUserByUsernameInput where
  toGraphQLArgumentValue (DeleteUserByUsernameInput x) = toGraphQLArgumentValue
                                                         x

-- | original name - DeleteUserEmailInput
newtype DeleteUserEmailInput = DeleteUserEmailInput { clientMutationId :: Optional
                                                                          String
                                                    , rowId :: Uuid
                                                    }

derive instance genericDeleteUserEmailInput :: Generic DeleteUserEmailInput _

derive instance newtypeDeleteUserEmailInput :: Newtype DeleteUserEmailInput _

instance toGraphQLArgumentValueDeleteUserEmailInput :: ToGraphQLArgumentValue
                                                       DeleteUserEmailInput where
  toGraphQLArgumentValue (DeleteUserEmailInput x) = toGraphQLArgumentValue x

-- | original name - DeleteUserEmailByIdInput
newtype DeleteUserEmailByIdInput = DeleteUserEmailByIdInput { clientMutationId :: Optional
                                                                                  String
                                                            , id :: Id
                                                            }

derive instance genericDeleteUserEmailByIdInput :: Generic DeleteUserEmailByIdInput _

derive instance newtypeDeleteUserEmailByIdInput :: Newtype DeleteUserEmailByIdInput _

instance toGraphQLArgumentValueDeleteUserEmailByIdInput :: ToGraphQLArgumentValue
                                                           DeleteUserEmailByIdInput where
  toGraphQLArgumentValue (DeleteUserEmailByIdInput x) = toGraphQLArgumentValue x

-- | original name - DeleteUserEmailByUserIdAndEmailInput
newtype DeleteUserEmailByUserIdAndEmailInput = DeleteUserEmailByUserIdAndEmailInput { clientMutationId :: Optional
                                                                                                          String
                                                                                    , email :: String
                                                                                    , userId :: Uuid
                                                                                    }

derive instance genericDeleteUserEmailByUserIdAndEmailInput :: Generic DeleteUserEmailByUserIdAndEmailInput _

derive instance newtypeDeleteUserEmailByUserIdAndEmailInput :: Newtype DeleteUserEmailByUserIdAndEmailInput _

instance toGraphQLArgumentValueDeleteUserEmailByUserIdAndEmailInput :: ToGraphQLArgumentValue
                                                                       DeleteUserEmailByUserIdAndEmailInput where
  toGraphQLArgumentValue (DeleteUserEmailByUserIdAndEmailInput x) = toGraphQLArgumentValue
                                                                    x

-- | original name - ForgotPasswordInput
newtype ForgotPasswordInput = ForgotPasswordInput { clientMutationId :: Optional
                                                                        String
                                                  , email :: String
                                                  }

derive instance genericForgotPasswordInput :: Generic ForgotPasswordInput _

derive instance newtypeForgotPasswordInput :: Newtype ForgotPasswordInput _

instance toGraphQLArgumentValueForgotPasswordInput :: ToGraphQLArgumentValue
                                                      ForgotPasswordInput where
  toGraphQLArgumentValue (ForgotPasswordInput x) = toGraphQLArgumentValue x

-- | original name - ResetPasswordInput
newtype ResetPasswordInput = ResetPasswordInput { clientMutationId :: Optional
                                                                      String
                                                , newPassword :: String
                                                , token :: String
                                                , userId :: Uuid
                                                }

derive instance genericResetPasswordInput :: Generic ResetPasswordInput _

derive instance newtypeResetPasswordInput :: Newtype ResetPasswordInput _

instance toGraphQLArgumentValueResetPasswordInput :: ToGraphQLArgumentValue
                                                     ResetPasswordInput where
  toGraphQLArgumentValue (ResetPasswordInput x) = toGraphQLArgumentValue x

-- | original name - UpdateUserInput
newtype UpdateUserInput = UpdateUserInput { clientMutationId :: Optional String
                                          , patch :: UserPatch
                                          , rowId :: Uuid
                                          }

derive instance genericUpdateUserInput :: Generic UpdateUserInput _

derive instance newtypeUpdateUserInput :: Newtype UpdateUserInput _

instance toGraphQLArgumentValueUpdateUserInput :: ToGraphQLArgumentValue
                                                  UpdateUserInput where
  toGraphQLArgumentValue (UpdateUserInput x) = toGraphQLArgumentValue x

-- | original name - UserPatch
newtype UserPatch = UserPatch { avatarUrl :: Optional String
                              , name :: Optional String
                              }

derive instance genericUserPatch :: Generic UserPatch _

derive instance newtypeUserPatch :: Newtype UserPatch _

instance toGraphQLArgumentValueUserPatch :: ToGraphQLArgumentValue UserPatch where
  toGraphQLArgumentValue (UserPatch x) = toGraphQLArgumentValue x

-- | original name - UpdateUserByIdInput
newtype UpdateUserByIdInput = UpdateUserByIdInput { clientMutationId :: Optional
                                                                        String
                                                  , id :: Id
                                                  , patch :: UserPatch
                                                  }

derive instance genericUpdateUserByIdInput :: Generic UpdateUserByIdInput _

derive instance newtypeUpdateUserByIdInput :: Newtype UpdateUserByIdInput _

instance toGraphQLArgumentValueUpdateUserByIdInput :: ToGraphQLArgumentValue
                                                      UpdateUserByIdInput where
  toGraphQLArgumentValue (UpdateUserByIdInput x) = toGraphQLArgumentValue x

-- | original name - UpdateUserByUsernameInput
newtype UpdateUserByUsernameInput = UpdateUserByUsernameInput { clientMutationId :: Optional
                                                                                    String
                                                              , patch :: UserPatch
                                                              , username :: String
                                                              }

derive instance genericUpdateUserByUsernameInput :: Generic UpdateUserByUsernameInput _

derive instance newtypeUpdateUserByUsernameInput :: Newtype UpdateUserByUsernameInput _

instance toGraphQLArgumentValueUpdateUserByUsernameInput :: ToGraphQLArgumentValue
                                                            UpdateUserByUsernameInput where
  toGraphQLArgumentValue (UpdateUserByUsernameInput x) = toGraphQLArgumentValue
                                                         x

-- | original name - UpsertUserEmailInput
newtype UpsertUserEmailInput = UpsertUserEmailInput { clientMutationId :: Optional
                                                                          String
                                                    , userEmail :: UserEmailInput
                                                    }

derive instance genericUpsertUserEmailInput :: Generic UpsertUserEmailInput _

derive instance newtypeUpsertUserEmailInput :: Newtype UpsertUserEmailInput _

instance toGraphQLArgumentValueUpsertUserEmailInput :: ToGraphQLArgumentValue
                                                       UpsertUserEmailInput where
  toGraphQLArgumentValue (UpsertUserEmailInput x) = toGraphQLArgumentValue x

-- | original name - VerifyUserEmailInput
newtype VerifyUserEmailInput = VerifyUserEmailInput { clientMutationId :: Optional
                                                                          String
                                                    , token :: String
                                                    }

derive instance genericVerifyUserEmailInput :: Generic VerifyUserEmailInput _

derive instance newtypeVerifyUserEmailInput :: Newtype VerifyUserEmailInput _

instance toGraphQLArgumentValueVerifyUserEmailInput :: ToGraphQLArgumentValue
                                                       VerifyUserEmailInput where
  toGraphQLArgumentValue (VerifyUserEmailInput x) = toGraphQLArgumentValue x

-- | original name - WebLoginInput
newtype WebLoginInput = WebLoginInput { password :: String, username :: String }

derive instance genericWebLoginInput :: Generic WebLoginInput _

derive instance newtypeWebLoginInput :: Newtype WebLoginInput _

instance toGraphQLArgumentValueWebLoginInput :: ToGraphQLArgumentValue
                                                WebLoginInput where
  toGraphQLArgumentValue (WebLoginInput x) = toGraphQLArgumentValue x

-- | original name - WebRegisterInput
newtype WebRegisterInput = WebRegisterInput { avatarUrl :: Optional String
                                            , email :: String
                                            , name :: Optional String
                                            , password :: String
                                            , username :: String
                                            }

derive instance genericWebRegisterInput :: Generic WebRegisterInput _

derive instance newtypeWebRegisterInput :: Newtype WebRegisterInput _

instance toGraphQLArgumentValueWebRegisterInput :: ToGraphQLArgumentValue
                                                   WebRegisterInput where
  toGraphQLArgumentValue (WebRegisterInput x) = toGraphQLArgumentValue x

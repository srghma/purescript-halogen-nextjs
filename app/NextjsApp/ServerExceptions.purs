module NextjsApp.ServerExceptions where

login_emailNotRegistered :: String
login_emailNotRegistered = "APP__EXCEPTION__LOGIN__EMAIL_NOT_REGISTERED"


login_notConfirmed :: String
login_notConfirmed = "APP__EXCEPTION__LOGIN__NOT_CONFIRMED"


login_wrongPassword :: String
login_wrongPassword = "APP__EXCEPTION__LOGIN__WRONG_PASSWORD"


resetPassword_tokenIsInvalid :: String
resetPassword_tokenIsInvalid = "APP__EXCEPTION__RESET_PASSWORD__TOKEN_IS_INVALID"


resetPassword_userNotConfirmed :: String
resetPassword_userNotConfirmed = "APP__EXCEPTION__RESET_PASSWORD__USER_NOT_CONFIRMED"


resendConfirmation_notRegistered :: String
resendConfirmation_notRegistered = "APP__EXCEPTION__RESEND_CONFIRMATION__NOT_REGISTERED"


resendConfirmation_alreadyConfirmed :: String
resendConfirmation_alreadyConfirmed = "APP__EXCEPTION__RESEND_CONFIRMATION__ALREADY_CONFIRMED"


register_alreadyRegistered :: String
register_alreadyRegistered = "APP__EXCEPTION__REGISTER__ALREADY_REGISTERED"


sendResetPassword_emailNotRegistered :: String
sendResetPassword_emailNotRegistered = "APP__EXCEPTION__SEND_RESET_PASSWORD__EMAIL_NOT_REGISTERED"


sendResetPassword_emailNotConfirmed :: String
sendResetPassword_emailNotConfirmed = "APP__EXCEPTION__SEND_RESET_PASSWORD__EMAIL_NOT_CONFIRMED"


confirm_tokenIsInvalidOrYouAreAlreadyConfirmed :: String
confirm_tokenIsInvalidOrYouAreAlreadyConfirmed = "APP__EXCEPTION__CONFIRM__TOKEN_IS_INVALID_OR_YOU_ARE_ALREADY_CONFIRMED"


validateSubscription_invalidUser :: String
validateSubscription_invalidUser = "APP__EXCEPTION__VALIDATE_SUBSCRIPTION__INVALID_USER"


validateSubscription_unknownTopic :: String
validateSubscription_unknownTopic = "APP__EXCEPTION__VALIDATE_SUBSCRIPTION__UNKNOWN_TOPIC"



sealed class ForgetPasswordIntent {
  const ForgetPasswordIntent();
}

class SendResetCodeIntent extends ForgetPasswordIntent {
  final String email;
  const SendResetCodeIntent(this.email);
}

class VerifyCodeIntent extends ForgetPasswordIntent {
  final String code;
  const VerifyCodeIntent(this.code);
}

class ResendCodeIntent extends ForgetPasswordIntent {
  const ResendCodeIntent();
}

class SubmitNewPasswordIntent extends ForgetPasswordIntent {
  final String newPassword;
  const SubmitNewPasswordIntent(this.newPassword);
}

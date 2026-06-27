part of 'reset_password_cubit.dart';

sealed class ResetPasswordEvent {
  const ResetPasswordEvent();
}

class SubmitResetPasswordEvent extends ResetPasswordEvent {
  final String password;
  final String newPassword;
  const SubmitResetPasswordEvent({
    required this.password,
    required this.newPassword,
  });
}

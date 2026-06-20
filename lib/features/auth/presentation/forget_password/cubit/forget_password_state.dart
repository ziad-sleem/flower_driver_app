part of 'forget_password_cubit.dart';

enum ForgetPasswordStep { email, verifyCode, resetPassword }

class ForgetPasswordState extends Equatable {
  final BaseState<ForgetPasswordEntity> sendCodeState;
  final BaseState<VerifyResetCodeEntity> verifyState;
  final BaseState<ResetPasswordEntity> resetState;
  final BaseState<ForgetPasswordEntity> resendState;
  final String email;
  final ForgetPasswordStep step;

  const ForgetPasswordState({
    this.sendCodeState = const BaseState(),
    this.verifyState = const BaseState(),
    this.resetState = const BaseState(),
    this.resendState = const BaseState(),
    this.email = '',
    this.step = ForgetPasswordStep.email,
  });

  ForgetPasswordState copyWith({
    BaseState<ForgetPasswordEntity>? sendCodeState,
    BaseState<VerifyResetCodeEntity>? verifyState,
    BaseState<ResetPasswordEntity>? resetState,
    BaseState<ForgetPasswordEntity>? resendState,
    String? email,
    ForgetPasswordStep? step,
  }) {
    return ForgetPasswordState(
      sendCodeState: sendCodeState ?? this.sendCodeState,
      verifyState: verifyState ?? this.verifyState,
      resetState: resetState ?? this.resetState,
      resendState: resendState ?? this.resendState,
      email: email ?? this.email,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [
    sendCodeState,
    verifyState,
    resetState,
    resendState,
    email,
    step,
  ];
}

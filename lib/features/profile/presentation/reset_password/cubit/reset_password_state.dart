part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  final BaseState<ResetPasswordResponseEntity> resetPasswordState;

  const ResetPasswordState({
    this.resetPasswordState = const BaseState(),
  });

  ResetPasswordState copyWith({
    BaseState<ResetPasswordResponseEntity>? resetPasswordState,
  }) {
    return ResetPasswordState(
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }

  @override
  List<Object?> get props => [resetPasswordState];
}

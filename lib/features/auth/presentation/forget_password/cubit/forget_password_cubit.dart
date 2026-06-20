import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/localization_constants/validation_constants.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_reset_code_usecase.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';

part 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _sendCodeUseCase;
  final VerifyResetCodeUseCase _verifyUseCase;
  final ResetPasswordUseCase _resetUseCase;

  ForgetPasswordCubit(
    this._sendCodeUseCase,
    this._verifyUseCase,
    this._resetUseCase,
  ) : super(const ForgetPasswordState());

  void doIntent(ForgetPasswordIntent intent) {
    switch (intent) {
      case SendResetCodeIntent():
        _sendCode(intent.email);
      case VerifyCodeIntent():
        _verifyCode(intent.code);
      case ResendCodeIntent():
        _resendCode();
      case SubmitNewPasswordIntent():
        _resetPassword(intent.newPassword);
    }
  }

  Future<void> _sendCode(String email) async {
    emit(
      state.copyWith(
        sendCodeState: const BaseState(isLoading: true),
        email: email,
      ),
    );
    final response = await _sendCodeUseCase(email: email);
    switch (response) {
      case SuccessBaseResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            sendCodeState: BaseState(data: response.data),
            step: ForgetPasswordStep.verifyCode,
          ),
        );
      case ErrorBaseResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            sendCodeState: BaseState(errorMessage: response.failure.message),
          ),
        );
    }
  }

  Future<void> _verifyCode(String code) async {
    emit(state.copyWith(verifyState: const BaseState(isLoading: true)));
    final response = await _verifyUseCase(resetCode: code);
    switch (response) {
      case SuccessBaseResponse<VerifyResetCodeEntity>():
        if (response.data.isValid) {
          emit(
            state.copyWith(
              verifyState: BaseState(data: response.data),
              step: ForgetPasswordStep.resetPassword,
            ),
          );
        } else {
          emit(
            state.copyWith(
              verifyState: BaseState(
                errorMessage: ValidationConstants.invalidCode,
              ),
            ),
          );
        }
      case ErrorBaseResponse<VerifyResetCodeEntity>():
        emit(
          state.copyWith(
            verifyState: BaseState(errorMessage: response.failure.message),
          ),
        );
    }
  }

  Future<void> _resendCode() async {
    if (state.resendState.isLoading) return;
    emit(state.copyWith(resendState: const BaseState(isLoading: true)));
    final response = await _sendCodeUseCase(email: state.email);
    switch (response) {
      case SuccessBaseResponse<ForgetPasswordEntity>():
        emit(state.copyWith(resendState: BaseState(data: response.data)));
      case ErrorBaseResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            resendState: BaseState(errorMessage: response.failure.message),
          ),
        );
    }
  }

  Future<void> _resetPassword(String newPassword) async {
    emit(state.copyWith(resetState: const BaseState(isLoading: true)));
    final response = await _resetUseCase(
      email: state.email,
      newPassword: newPassword,
    );
    switch (response) {
      case SuccessBaseResponse<ResetPasswordEntity>():
        emit(state.copyWith(resetState: BaseState(data: response.data)));
      case ErrorBaseResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetState: BaseState(errorMessage: response.failure.message),
          ),
        );
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/reset_password_use_case.dart';
part 'reset_password_state.dart';
part 'reset_password_event.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(const ResetPasswordState());

  void doEvent(ResetPasswordEvent event) {
    switch (event) {
      case SubmitResetPasswordEvent e:
        _resetPassword(e);
    }
  }

  Future<void> _resetPassword(SubmitResetPasswordEvent event) async {
    try {
      emit(state.copyWith(resetPasswordState: const BaseState(isLoading: true)));

      final response = await _resetPasswordUseCase(
        password: event.password,
        newPassword: event.newPassword,
      );

      switch (response) {
        case SuccessBaseResponse<ResetPasswordResponseEntity>():
          emit(
            state.copyWith(
              resetPasswordState: BaseState(data: response.data),
            ),
          );
        case ErrorBaseResponse<ResetPasswordResponseEntity>():
          emit(
            state.copyWith(
              resetPasswordState: BaseState(
                errorMessage: response.failure.message,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          resetPasswordState: BaseState(
            isLoading: false,
            errorMessage: ErrorHandler.handle(e).message,
          ),
        ),
      );
    }
  }
}

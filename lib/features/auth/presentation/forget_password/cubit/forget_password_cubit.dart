import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';

part 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _useCase;

  ForgetPasswordCubit(this._useCase) : super(const ForgetPasswordState());

  void doIntent(ForgetPasswordIntent intent) {
    if (intent is SubmitForgetPasswordIntent) {
      _submit(intent.email);
    }
  }

  Future<void> _submit(String email) async {
    emit(state.copyWith(base: const BaseState(isLoading: true), email: email));
    final response = await _useCase(email: email);
    if (response is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(base: BaseState(data: response.data)));
    } else if (response is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(
        state.copyWith(base: BaseState(errorMessage: response.failure.message)),
      );
    }
  }
}

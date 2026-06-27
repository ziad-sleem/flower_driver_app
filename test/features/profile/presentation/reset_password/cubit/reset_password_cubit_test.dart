import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/reset_password_use_case.dart';
import 'package:tracking_app/features/profile/presentation/reset_password/cubit/reset_password_cubit.dart';

import 'reset_password_cubit_test.mocks.dart';

@GenerateMocks([ResetPasswordUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ResetPasswordCubit resetPasswordCubit;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<ResetPasswordResponseEntity>>(
      SuccessBaseResponse<ResetPasswordResponseEntity>(
        data: ResetPasswordResponseEntity(message: '', token: ''),
      ),
    );
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async => null,
    );
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    resetPasswordCubit = ResetPasswordCubit(mockResetPasswordUseCase);
  });

  tearDown(() {
    resetPasswordCubit.close();
  });

  group('ResetPasswordCubit', () {
    test('initial state is correct', () {
      expect(resetPasswordCubit.state.resetPasswordState.isLoading, false);
      expect(resetPasswordCubit.state.resetPasswordState.data, isNull);
      expect(resetPasswordCubit.state.resetPasswordState.errorMessage, isNull);
    });

    group('SubmitResetPasswordEvent', () {
      const tPassword = "oldPass123";
      const tNewPassword = "newPass456";
      final tResponse = ResetPasswordResponseEntity(
        message: "Password changed successfully",
        token: "new_token",
      );

      test('emits loading then success when reset password succeeds', () async {
        when(mockResetPasswordUseCase(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        )).thenAnswer(
          (_) async => SuccessBaseResponse<ResetPasswordResponseEntity>(
            data: tResponse,
          ),
        );

        resetPasswordCubit.doEvent(
          SubmitResetPasswordEvent(
            password: tPassword,
            newPassword: tNewPassword,
          ),
        );

        expect(resetPasswordCubit.state.resetPasswordState.isLoading, true);
        expect(resetPasswordCubit.state.resetPasswordState.data, isNull);

        await Future.delayed(Duration.zero);

        expect(resetPasswordCubit.state.resetPasswordState.isLoading, false);
        expect(
          resetPasswordCubit.state.resetPasswordState.data,
          tResponse,
        );
        verify(mockResetPasswordUseCase(
          password: tPassword,
          newPassword: tNewPassword,
        )).called(1);
      });

      test('emits loading then error when reset password fails', () async {
        final tFailure = Failure(message: "Invalid current password");
        when(mockResetPasswordUseCase(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        )).thenAnswer(
          (_) async => ErrorBaseResponse<ResetPasswordResponseEntity>(
            failure: tFailure,
          ),
        );

        resetPasswordCubit.doEvent(
          SubmitResetPasswordEvent(
            password: tPassword,
            newPassword: tNewPassword,
          ),
        );

        expect(resetPasswordCubit.state.resetPasswordState.isLoading, true);

        await Future.delayed(Duration.zero);

        expect(resetPasswordCubit.state.resetPasswordState.isLoading, false);
        expect(
          resetPasswordCubit.state.resetPasswordState.errorMessage,
          "Invalid current password",
        );
      });

      test('emits error when use case throws', () async {
        when(mockResetPasswordUseCase(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        )).thenThrow(Exception("Unexpected error"));

        resetPasswordCubit.doEvent(
          SubmitResetPasswordEvent(
            password: tPassword,
            newPassword: tNewPassword,
          ),
        );

        await Future.delayed(Duration.zero);

        expect(resetPasswordCubit.state.resetPasswordState.isLoading, false);
        expect(
          resetPasswordCubit.state.resetPasswordState.errorMessage,
          isNotNull,
        );
      });
    });
  });
}

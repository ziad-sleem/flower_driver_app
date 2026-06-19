import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_reset_code_usecase.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';

import 'forget_password_cubit_test.mocks.dart';

@GenerateMocks([
  ForgetPasswordUseCase,
  VerifyResetCodeUseCase,
  ResetPasswordUseCase,
])
void main() {
  late MockForgetPasswordUseCase sendCodeUseCase;
  late MockVerifyResetCodeUseCase verifyUseCase;
  late MockResetPasswordUseCase resetUseCase;
  late ForgetPasswordCubit cubit;

  setUpAll(() {
    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      ErrorBaseResponse<ForgetPasswordEntity>(failure: Failure(message: '')),
    );
    provideDummy<BaseResponse<VerifyResetCodeEntity>>(
      ErrorBaseResponse<VerifyResetCodeEntity>(failure: Failure(message: '')),
    );
    provideDummy<BaseResponse<ResetPasswordEntity>>(
      ErrorBaseResponse<ResetPasswordEntity>(failure: Failure(message: '')),
    );
  });

  setUp(() {
    sendCodeUseCase = MockForgetPasswordUseCase();
    verifyUseCase = MockVerifyResetCodeUseCase();
    resetUseCase = MockResetPasswordUseCase();
    cubit = ForgetPasswordCubit(sendCodeUseCase, verifyUseCase, resetUseCase);
  });

  group('send reset code', () {
    test('emits [loading, success + step=verifyCode] on success', () async {
      when(sendCodeUseCase(email: anyNamed('email'))).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const ForgetPasswordEntity(message: 'sent', info: 'check'),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.sendCodeState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>()
              .having((s) => s.sendCodeState.data, 'data', isNotNull)
              .having((s) => s.step, 'step', ForgetPasswordStep.verifyCode),
        ]),
      );

      cubit.doIntent(const SendResetCodeIntent('a@b.com'));
      await expectation;
    });

    test('emits [loading, error] on failure', () async {
      when(
        sendCodeUseCase(email: anyNamed('email')),
      ).thenAnswer((_) async => ErrorBaseResponse(failure: Failure(message: 'oops')));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.sendCodeState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>().having(
            (s) => s.sendCodeState.errorMessage,
            'errorMessage',
            'oops',
          ),
        ]),
      );

      cubit.doIntent(const SendResetCodeIntent('a@b.com'));
      await expectation;
    });
  });

  group('verify code', () {
    test('valid code emits data + step=resetPassword', () async {
      when(verifyUseCase(resetCode: anyNamed('resetCode'))).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const VerifyResetCodeEntity(status: 'Success'),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.verifyState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>()
              .having((s) => s.verifyState.data, 'data', isNotNull)
              .having((s) => s.step, 'step', ForgetPasswordStep.resetPassword),
        ]),
      );

      cubit.doIntent(const VerifyCodeIntent('1234'));
      await expectation;
    });

    test('invalid status emits codeHasError', () async {
      when(verifyUseCase(resetCode: anyNamed('resetCode'))).thenAnswer(
        (_) async =>
            SuccessBaseResponse(data: const VerifyResetCodeEntity(status: 'Fail')),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.verifyState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>().having(
            (s) => s.verifyState.errorMessage,
            'errorMessage',
            isNotNull,
          ),
        ]),
      );

      cubit.doIntent(const VerifyCodeIntent('0000'));
      await expectation;
    });

    test('failure emits codeHasError + message', () async {
      when(
        verifyUseCase(resetCode: anyNamed('resetCode')),
      ).thenAnswer((_) async => ErrorBaseResponse(failure: Failure(message: 'net')));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.verifyState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>().having(
            (s) => s.verifyState.errorMessage,
            'errorMessage',
            'net',
          ),
        ]),
      );

      cubit.doIntent(const VerifyCodeIntent('0000'));
      await expectation;
    });
  });

  group('reset password', () {
    test('emits [loading, success] on success', () async {
      when(
        resetUseCase(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const ResetPasswordEntity(message: 'ok', token: 't'),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.resetState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>().having(
            (s) => s.resetState.data,
            'data',
            isNotNull,
          ),
        ]),
      );

      cubit.doIntent(const SubmitNewPasswordIntent('P@ssw0rd!'));
      await expectation;
    });

    test('emits [loading, error] on failure', () async {
      when(
        resetUseCase(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => ErrorBaseResponse(failure: Failure(message: 'boom')));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordState>().having(
            (s) => s.resetState.isLoading,
            'loading',
            true,
          ),
          isA<ForgetPasswordState>().having(
            (s) => s.resetState.errorMessage,
            'errorMessage',
            'boom',
          ),
        ]),
      );

      cubit.doIntent(const SubmitNewPasswordIntent('P@ssw0rd!'));
      await expectation;
    });
  });
}

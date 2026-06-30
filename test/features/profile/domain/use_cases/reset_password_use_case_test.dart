import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';
import 'package:tracking_app/features/profile/domain/use_cases/reset_password_use_case.dart';

import 'reset_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  late ResetPasswordUseCase resetPasswordUseCase;
  late MockProfileRepo mockProfileRepo;

  setUpAll(() {
    provideDummy<BaseResponse<ResetPasswordResponseEntity>>(
      SuccessBaseResponse<ResetPasswordResponseEntity>(
        data: ResetPasswordResponseEntity(message: '', token: ''),
      ),
    );
  });

  setUp(() {
    mockProfileRepo = MockProfileRepo();
    resetPasswordUseCase = ResetPasswordUseCase(mockProfileRepo);
  });

  group('ResetPasswordUseCase', () {
    const tPassword = "oldPass123";
    const tNewPassword = "newPass456";
    final tEntity = ResetPasswordResponseEntity(
      message: "Password changed successfully",
      token: "new_token",
    );
    final tFailure = Failure(message: "Failed to change password");

    test('should call profileRepo.resetPassword with correct params', () async {
      when(
        mockProfileRepo.resetPassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => SuccessBaseResponse<ResetPasswordResponseEntity>(
          data: tEntity,
        ),
      );

      final result = await resetPasswordUseCase(
        password: tPassword,
        newPassword: tNewPassword,
      );

      verify(
        mockProfileRepo.resetPassword(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ).called(1);
      expect(result, isA<SuccessBaseResponse<ResetPasswordResponseEntity>>());
      expect(
        (result as SuccessBaseResponse<ResetPasswordResponseEntity>).data,
        tEntity,
      );
    });

    test('should return error when profileRepo.resetPassword fails', () async {
      when(
        mockProfileRepo.resetPassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse<ResetPasswordResponseEntity>(
          failure: tFailure,
        ),
      );

      final result = await resetPasswordUseCase(
        password: tPassword,
        newPassword: tNewPassword,
      );

      expect(result, isA<ErrorBaseResponse<ResetPasswordResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<ResetPasswordResponseEntity>)
            .failure
            .message,
        "Failed to change password",
      );
    });
  });
}

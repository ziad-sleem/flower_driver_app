import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepo mockAuthRepo;

  setUpAll(() {
    provideDummy<BaseResponse<UserEntity>>(
      SuccessBaseResponse<UserEntity>(data: UserEntity()),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    loginUseCase = LoginUseCase(authRepo: mockAuthRepo);
  });

  group('LoginUseCase', () {
    const tParams = LoginParams(email: "test@example.com", password: "password123");
    final tUser = UserEntity(id: "1", email: "test@example.com");
    final tFailure = Failure(message: "Login failed");

    test('should call authRepo.login with correct params', () async {
      when(mockAuthRepo.login(tParams)).thenAnswer(
        (_) async => SuccessBaseResponse<UserEntity>(data: tUser),
      );

      final result = await loginUseCase(tParams);

      verify(mockAuthRepo.login(tParams)).called(1);
      expect(result, isA<SuccessBaseResponse<UserEntity>>());
      expect((result as SuccessBaseResponse<UserEntity>).data, tUser);
    });

    test('should return error when authRepo.login fails', () async {
      when(mockAuthRepo.login(tParams)).thenAnswer(
        (_) async => ErrorBaseResponse<UserEntity>(failure: tFailure),
      );

      final result = await loginUseCase(tParams);

      expect(result, isA<ErrorBaseResponse<UserEntity>>());
      expect(
        (result as ErrorBaseResponse<UserEntity>).failure.message,
        "Login failed",
      );
    });
  });
}

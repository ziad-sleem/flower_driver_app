import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/network/model/user.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, UserDto])
void main() {
  late AuthRepoImpl authRepoImpl;
  late MockAuthRemoteDataSourceContract mockDataSource;
  late MockUserDto mockUserDto;

  setUpAll(() {
    provideDummy<BaseResponse<UserDto>>(
      SuccessBaseResponse<UserDto>(data: UserDto()),
    );
  });

  setUp(() {
    mockDataSource = MockAuthRemoteDataSourceContract();
    mockUserDto = MockUserDto();
    authRepoImpl = AuthRepoImpl(authRemoteDataSourceContract: mockDataSource);
  });

  group('AuthRepoImpl', () {
    const tParams = LoginParams(email: "test@example.com", password: "password123");
    final tFailure = Failure(message: "Login failed");
    final tUserEntity = UserEntity(id: "1", email: "test@example.com");

    test('should return success with mapped entity when data source succeeds', () async {
      when(mockUserDto.toDomain()).thenReturn(tUserEntity);
      when(mockDataSource.login(tParams)).thenAnswer(
        (_) async => SuccessBaseResponse<UserDto>(data: mockUserDto),
      );

      final result = await authRepoImpl.login(tParams);

      expect(result, isA<SuccessBaseResponse<UserEntity>>());
      expect((result as SuccessBaseResponse<UserEntity>).data, tUserEntity);
      verify(mockDataSource.login(tParams)).called(1);
      verify(mockUserDto.toDomain()).called(1);
    });

    test('should return error when data source fails', () async {
      when(mockDataSource.login(tParams)).thenAnswer(
        (_) async => ErrorBaseResponse<UserDto>(failure: tFailure),
      );

      final result = await authRepoImpl.login(tParams);

      expect(result, isA<ErrorBaseResponse<UserEntity>>());
      expect(
        (result as ErrorBaseResponse<UserEntity>).failure.message,
        "Login failed",
      );
      verify(mockDataSource.login(tParams)).called(1);
      verifyNever(mockUserDto.toDomain());
    });
  });
}

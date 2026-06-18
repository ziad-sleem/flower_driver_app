import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/localization_constants/error_massage_constants.dart';
import 'package:tracking_app/core/network/model/user.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/auth/api/datasources/auth_remote_data_source_impl.dart';
import 'package:tracking_app/features/auth/data/models/requests/login_request.dart';
import 'package:tracking_app/features/auth/data/models/response/login_response.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApiClient mockApiClient;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async => null,
    );
    mockApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(authApiClient: mockApiClient);
  });



  group('AuthRemoteDataSourceImpl', () {
    const tParams = LoginParams(email: "test@example.com", password: "password123");
    const tToken = "test_token_value";

    test('should return success and save token when token is present', () async {
      when(mockApiClient.login(any)).thenAnswer(
        (_) async => LoginResponse(message: "Success", token: tToken),
      );

      final result = await dataSource.login(tParams);

      expect(result, isA<SuccessBaseResponse<UserDto>>());
      verify(mockApiClient.login(
        argThat(
          isA<LoginRequest>().having(
            (r) => r.email,
            'email',
            tParams.email,
          ),
        ),
      )).called(1);
    });

    test('should return error when token is null', () async {
      when(mockApiClient.login(any)).thenAnswer(
        (_) async => LoginResponse(message: "Error message", token: null),
      );

      final result = await dataSource.login(tParams);

      expect(result, isA<ErrorBaseResponse<UserDto>>());
      expect(
        (result as ErrorBaseResponse<UserDto>).failure.message,
        "Error message",
      );
    });

    test('should return error with loginError constant when token is null and message is null', () async {
      when(mockApiClient.login(any)).thenAnswer(
        (_) async => LoginResponse(message: null, token: null),
      );

      final result = await dataSource.login(tParams);

      expect(result, isA<ErrorBaseResponse<UserDto>>());
      expect(
        (result as ErrorBaseResponse<UserDto>).failure.message,
        ErrorConstants.loginError,
      );
    });

    test('should return error when token is empty string', () async {
      when(mockApiClient.login(any)).thenAnswer(
        (_) async => LoginResponse(message: "No token", token: ""),
      );

      final result = await dataSource.login(tParams);

      expect(result, isA<ErrorBaseResponse<UserDto>>());
      expect(
        (result as ErrorBaseResponse<UserDto>).failure.message,
        "No token",
      );
    });

    test('should return error when api client throws', () async {
      when(mockApiClient.login(any)).thenThrow(
        Exception("Network error"),
      );

      final result = await dataSource.login(tParams);

      expect(result, isA<ErrorBaseResponse<UserDto>>());
    });
  });
}

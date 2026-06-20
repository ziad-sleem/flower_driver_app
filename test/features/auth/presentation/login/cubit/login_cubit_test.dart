import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_event.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LoginCubit loginCubit;
  late MockLoginUseCase mockLoginUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<UserEntity>>(
      SuccessBaseResponse<UserEntity>(data: UserEntity()),
    );
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async => null,
    );
    mockLoginUseCase = MockLoginUseCase();
    loginCubit = LoginCubit(mockLoginUseCase);
  });

  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit', () {
    test('initial state is correct', () {
      expect(loginCubit.state.loginState.isLoading, false);
      expect(loginCubit.state.loginState.data, isNull);
      expect(loginCubit.state.loginState.errorMessage, isNull);
      expect(loginCubit.state.rememberMe, false);
    });

    group('RememberMeChanged', () {
      test('updates rememberMe to true and resets loginState', () {
        loginCubit.doEvent(RememberMeChanged(true));

        expect(loginCubit.state.rememberMe, true);
        expect(loginCubit.state.loginState, const BaseState<UserEntity>());
      });

      test('updates rememberMe to false and resets loginState', () {
        loginCubit.doEvent(RememberMeChanged(true));
        loginCubit.doEvent(RememberMeChanged(false));

        expect(loginCubit.state.rememberMe, false);
        expect(loginCubit.state.loginState, const BaseState<UserEntity>());
      });
    });

    group('Login', () {
      const tEmail = "test@example.com";
      const tPassword = "password123";
      final tUser = UserEntity(id: "1", email: tEmail);

      test('emits loading then success when login is successful and rememberMe is true', () async {
        loginCubit.doEvent(RememberMeChanged(true));

        when(mockLoginUseCase.call(
          argThat(
            isA<LoginParams>()
                .having((p) => p.email, 'email', tEmail)
                .having((p) => p.password, 'password', tPassword),
          ),
        )).thenAnswer(
          (_) async => SuccessBaseResponse<UserEntity>(data: tUser),
        );

        loginCubit.doEvent(Login(email: tEmail, password: tPassword));

        expect(loginCubit.state.loginState.isLoading, true);
        expect(loginCubit.state.loginState.data, isNull);

        await Future.delayed(Duration.zero);

        expect(loginCubit.state.loginState.isLoading, false);
        expect(loginCubit.state.loginState.data, tUser);
        verify(mockLoginUseCase.call(any)).called(1);
      });

      test('emits loading then error when login fails', () async {
        loginCubit.doEvent(RememberMeChanged(true));

        final tFailure = Failure(message: "Invalid credentials");
        when(mockLoginUseCase.call(any)).thenAnswer(
          (_) async => ErrorBaseResponse<UserEntity>(failure: tFailure),
        );

        loginCubit.doEvent(Login(email: tEmail, password: tPassword));

        expect(loginCubit.state.loginState.isLoading, true);

        await Future.delayed(Duration.zero);

        expect(loginCubit.state.loginState.isLoading, false);
        expect(loginCubit.state.loginState.errorMessage, "Invalid credentials");
      });

      test('emits error when use case throws', () async {
        loginCubit.doEvent(RememberMeChanged(true));

        when(mockLoginUseCase.call(any)).thenThrow(
          Exception("Unexpected error"),
        );

        loginCubit.doEvent(Login(email: tEmail, password: tPassword));

        await Future.delayed(Duration.zero);

        expect(loginCubit.state.loginState.isLoading, false);
        expect(loginCubit.state.loginState.errorMessage, isNotNull);
      });
    });
  });
}

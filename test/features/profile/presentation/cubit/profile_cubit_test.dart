import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile_event.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([GetDriverDataUseCase, GetVehiclesUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProfileCubit profileCubit;
  late MockGetDriverDataUseCase mockGetDriverDataUseCase;
  late MockGetVehiclesUseCase mockGetVehiclesUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileDataResponseEntity>>(
      SuccessBaseResponse<ProfileDataResponseEntity>(
        data: const ProfileDataResponseEntity(),
      ),
    );
    provideDummy<BaseResponse<AllVehiclesResponseEntity>>(
      SuccessBaseResponse<AllVehiclesResponseEntity>(
        data: const AllVehiclesResponseEntity(),
      ),
    );

    const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async => null);
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  setUp(() {
    mockGetDriverDataUseCase = MockGetDriverDataUseCase();
    mockGetVehiclesUseCase = MockGetVehiclesUseCase();
    profileCubit = ProfileCubit(mockGetDriverDataUseCase, mockGetVehiclesUseCase);
  });

  tearDown(() {
    profileCubit.close();
  });

  group('ProfileCubit', () {
    test('initial state is correct', () {
      expect(profileCubit.state.driverDataState.isLoading, false);
      expect(profileCubit.state.driverDataState.data, isNull);
      expect(profileCubit.state.driverDataState.errorMessage, isNull);
      expect(profileCubit.state.vehiclesState.isLoading, false);
      expect(profileCubit.state.vehiclesState.data, isNull);
      expect(profileCubit.state.vehiclesState.errorMessage, isNull);
      expect(profileCubit.state.targetLocale, isNull);
      expect(profileCubit.state.loggedOut, false);
    });

    group('GetDriverDataEvent', () {
      final tDriver = const ProfileDriverEntity(
        id: "1",
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
      );
      final tResponse = ProfileDataResponseEntity(
        message: "success",
        driver: tDriver,
      );

      test('emits loading then success when getDriverData succeeds', () async {
        when(mockGetDriverDataUseCase.call()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<ProfileDataResponseEntity>(data: tResponse),
        );

        profileCubit.doEvent(GetDriverDataEvent());

        expect(profileCubit.state.driverDataState.isLoading, true);
        expect(profileCubit.state.driverDataState.data, isNull);

        await Future.delayed(Duration.zero);

        expect(profileCubit.state.driverDataState.isLoading, false);
        expect(profileCubit.state.driverDataState.data, tResponse);
        verify(mockGetDriverDataUseCase.call()).called(1);
      });

      test('emits loading then error when getDriverData fails', () async {
        final tFailure = Failure(message: "Failed to load driver data");
        when(mockGetDriverDataUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse<ProfileDataResponseEntity>(
            failure: tFailure,
          ),
        );

        profileCubit.doEvent(GetDriverDataEvent());

        expect(profileCubit.state.driverDataState.isLoading, true);

        await Future.delayed(Duration.zero);

        expect(profileCubit.state.driverDataState.isLoading, false);
        expect(
          profileCubit.state.driverDataState.errorMessage,
          "Failed to load driver data",
        );
      });

      test('emits error when getDriverData throws', () async {
        when(mockGetDriverDataUseCase.call()).thenThrow(
          Exception("Unexpected error"),
        );

        profileCubit.doEvent(GetDriverDataEvent());

        await Future.delayed(Duration.zero);

        expect(profileCubit.state.driverDataState.isLoading, false);
        expect(profileCubit.state.driverDataState.errorMessage, isNotNull);
      });
    });

    group('GetVehiclesEvent', () {
      final tVehicles = [
        const VehicleEntity(id: "1", type: "car", image: "car.jpg"),
        const VehicleEntity(id: "2", type: "truck", image: "truck.jpg"),
      ];
      final tResponse = AllVehiclesResponseEntity(
        message: "success",
        vehicles: tVehicles,
      );

      test('emits loading then success when getVehicles succeeds', () async {
        when(mockGetVehiclesUseCase.call()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<AllVehiclesResponseEntity>(data: tResponse),
        );

        profileCubit.doEvent(GetVehiclesEvent());

        expect(profileCubit.state.vehiclesState.isLoading, true);
        expect(profileCubit.state.vehiclesState.data, isNull);

        await Future.delayed(Duration.zero);

        expect(profileCubit.state.vehiclesState.isLoading, false);
        expect(profileCubit.state.vehiclesState.data, tResponse);
        verify(mockGetVehiclesUseCase.call()).called(1);
      });

      test('emits loading then error when getVehicles fails', () async {
        final tFailure = Failure(message: "Failed to load vehicles");
        when(mockGetVehiclesUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse<AllVehiclesResponseEntity>(
            failure: tFailure,
          ),
        );

        profileCubit.doEvent(GetVehiclesEvent());

        expect(profileCubit.state.vehiclesState.isLoading, true);

        await Future.delayed(Duration.zero);

        expect(profileCubit.state.vehiclesState.isLoading, false);
        expect(
          profileCubit.state.vehiclesState.errorMessage,
          "Failed to load vehicles",
        );
      });

      test('emits error when getVehicles throws', () async {
        when(mockGetVehiclesUseCase.call()).thenThrow(
          Exception("Unexpected error"),
        );

        profileCubit.doEvent(GetVehiclesEvent());

        await Future.delayed(Duration.zero);

        expect(profileCubit.state.vehiclesState.isLoading, false);
        expect(profileCubit.state.vehiclesState.errorMessage, isNotNull);
      });
    });

    group('ToggleLanguageEvent', () {
      test('toggles from default (null) to arabic', () {
        expect(profileCubit.state.targetLocale, isNull);

        profileCubit.doEvent(ToggleLanguageEvent());

        expect(profileCubit.state.targetLocale, const Locale('ar'));
      });

      test('toggles from arabic to english', () {
        profileCubit.doEvent(ToggleLanguageEvent());
        expect(profileCubit.state.targetLocale, const Locale('ar'));

        profileCubit.doEvent(ToggleLanguageEvent());

        expect(profileCubit.state.targetLocale, const Locale('en'));
      });
    });

    group('LogoutEvent', () {
      test('emits loggedOut true after logout', () async {
        expect(profileCubit.state.loggedOut, false);

        profileCubit.doEvent(LogoutEvent());
        await Future.delayed(Duration.zero);

        expect(profileCubit.state.loggedOut, true);
      });
    });
  });
}

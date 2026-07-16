import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:tracking_app/features/profile/api/datasources/profile_remote_data_source_impl.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_dto.dart';
import 'package:tracking_app/features/profile/data/models/vehicle_dto.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late ProfileRemoteDataSourceImpl dataSource;
  late MockProfileApiClient mockApiClient;
  late SafeApiCaller safeApiCaller;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    safeApiCaller = SafeApiCaller();
    dataSource = ProfileRemoteDataSourceImpl(
      profileApiClient: mockApiClient,
      safeApiCaller: safeApiCaller,
    );
  });

  group('getProfileData', () {
    final tDriverDto = ProfileDriverDto(
      id: "1",
      firstName: "John",
      lastName: "Doe",
      email: "john@example.com",
    );
    final tResponseDto = ProfileDataResponseDto(
      message: "success",
      driver: tDriverDto,
    );

    test('should return success when api client succeeds', () async {
      when(mockApiClient.getProfileData()).thenAnswer(
        (_) async => tResponseDto,
      );

      final result = await dataSource.getProfileData();

      expect(result, isA<SuccessBaseResponse<ProfileDataResponseDto>>());
      expect(
        (result as SuccessBaseResponse<ProfileDataResponseDto>).data,
        tResponseDto,
      );
      verify(mockApiClient.getProfileData()).called(1);
    });

    test('should return error when api client throws', () async {
      when(mockApiClient.getProfileData()).thenThrow(
        Exception("Network error"),
      );

      final result = await dataSource.getProfileData();

      expect(result, isA<ErrorBaseResponse<ProfileDataResponseDto>>());
      verify(mockApiClient.getProfileData()).called(1);
    });
  });

  group('getVehicles', () {
    final tVehiclesDto = <VehicleDto>[
      VehicleDto(id: "1", type: "car", image: "car.jpg"),
    ];
    final tResponseDto = AllVehiclesResponseDto(
      message: "success",
      vehicles: tVehiclesDto,
    );

    test('should return success when api client succeeds', () async {
      when(mockApiClient.getVehicles()).thenAnswer(
        (_) async => tResponseDto,
      );

      final result = await dataSource.getVehicles();

      expect(result, isA<SuccessBaseResponse<AllVehiclesResponseDto>>());
      expect(
        (result as SuccessBaseResponse<AllVehiclesResponseDto>).data,
        tResponseDto,
      );
      verify(mockApiClient.getVehicles()).called(1);
    });

    test('should return error when api client throws', () async {
      when(mockApiClient.getVehicles()).thenThrow(
        Exception("Network error"),
      );

      final result = await dataSource.getVehicles();

      expect(result, isA<ErrorBaseResponse<AllVehiclesResponseDto>>());
      verify(mockApiClient.getVehicles()).called(1);
    });
  });
}

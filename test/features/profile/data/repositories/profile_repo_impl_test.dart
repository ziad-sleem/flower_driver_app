import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_dto.dart';
import 'package:tracking_app/features/profile/data/models/vehicle_dto.dart';
import 'package:tracking_app/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
void main() {
  late ProfileRepoImpl repo;
  late MockProfileRemoteDataSourceContract mockDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileDataResponseDto>>(
      SuccessBaseResponse<ProfileDataResponseDto>(
        data: ProfileDataResponseDto(),
      ),
    );
    provideDummy<BaseResponse<AllVehiclesResponseDto>>(
      SuccessBaseResponse<AllVehiclesResponseDto>(
        data: AllVehiclesResponseDto(),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockProfileRemoteDataSourceContract();
    repo = ProfileRepoImpl(profileRemoteDataSourceContract: mockDataSource);
  });

  group('ProfileRepoImpl.getProfileData', () {
    final tDriverDto = ProfileDriverDto(
      id: "1",
      firstName: "John",
      lastName: "Doe",
      email: "john@example.com",
      phone: "123456789",
    );
    final tResponseDto = ProfileDataResponseDto(
      message: "success",
      driver: tDriverDto,
    );
    final tDriverEntity = ProfileDriverEntity(
      id: "1",
      firstName: "John",
      lastName: "Doe",
      email: "john@example.com",
      phone: "123456789",
    );
    final tResponseEntity = ProfileDataResponseEntity(
      message: "success",
      driver: tDriverEntity,
    );

    test('should return success with mapped entity when data source succeeds', () async {
      when(mockDataSource.getProfileData()).thenAnswer(
        (_) async =>
            SuccessBaseResponse<ProfileDataResponseDto>(data: tResponseDto),
      );

      final result = await repo.getProfileData();

      expect(result, isA<SuccessBaseResponse<ProfileDataResponseEntity>>());
      expect(
        (result as SuccessBaseResponse<ProfileDataResponseEntity>).data,
        tResponseEntity,
      );
      verify(mockDataSource.getProfileData()).called(1);
    });

    test('should return error when data source fails', () async {
      final tFailure = Failure(message: "Failed");
      when(mockDataSource.getProfileData()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<ProfileDataResponseDto>(failure: tFailure),
      );

      final result = await repo.getProfileData();

      expect(result, isA<ErrorBaseResponse<ProfileDataResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<ProfileDataResponseEntity>).failure.message,
        "Failed",
      );
      verify(mockDataSource.getProfileData()).called(1);
    });
  });

  group('ProfileRepoImpl.getVehicles', () {
    final tVehiclesDto = <ProfileVehicleDto>[
      ProfileVehicleDto(id: "1", type: "car", image: "car.jpg"),
    ];
    final tResponseDto = AllVehiclesResponseDto(
      message: "success",
      vehicles: tVehiclesDto,
    );
    final tResponseEntity = AllVehiclesResponseEntity(
      message: "success",
      vehicles: [
        const ProfileVehicleEntity(id: "1", type: "car", image: "car.jpg"),
      ],
    );

    test('should return success with mapped entity when data source succeeds', () async {
      when(mockDataSource.getVehicles()).thenAnswer(
        (_) async =>
            SuccessBaseResponse<AllVehiclesResponseDto>(data: tResponseDto),
      );

      final result = await repo.getVehicles();

      expect(result, isA<SuccessBaseResponse<AllVehiclesResponseEntity>>());
      expect(
        (result as SuccessBaseResponse<AllVehiclesResponseEntity>).data,
        tResponseEntity,
      );
      verify(mockDataSource.getVehicles()).called(1);
    });

    test('should return error when data source fails', () async {
      final tFailure = Failure(message: "Failed");
      when(mockDataSource.getVehicles()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<AllVehiclesResponseDto>(failure: tFailure),
      );

      final result = await repo.getVehicles();

      expect(result, isA<ErrorBaseResponse<AllVehiclesResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<AllVehiclesResponseEntity>).failure.message,
        "Failed",
      );
      verify(mockDataSource.getVehicles()).called(1);
    });
  });
}

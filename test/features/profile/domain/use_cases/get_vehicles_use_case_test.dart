import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicles_use_case.dart';

import 'get_vehicles_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  late GetVehiclesUseCase useCase;
  late MockProfileRepo mockRepo;

  setUpAll(() {
    provideDummy<BaseResponse<AllVehiclesResponseEntity>>(
      SuccessBaseResponse<AllVehiclesResponseEntity>(
        data: const AllVehiclesResponseEntity(),
      ),
    );
  });

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = GetVehiclesUseCase(profileRepo: mockRepo);
  });

  group('GetVehiclesUseCase', () {
    final tVehicles = [
      const ProfileVehicleEntity(id: "1", type: "car", image: "car.jpg"),
      const ProfileVehicleEntity(id: "2", type: "truck", image: "truck.jpg"),
    ];
    final tResponse = AllVehiclesResponseEntity(
      message: "success",
      vehicles: tVehicles,
    );

    test('should return success response from repo', () async {
      when(mockRepo.getVehicles()).thenAnswer(
        (_) async =>
            SuccessBaseResponse<AllVehiclesResponseEntity>(data: tResponse),
      );

      final result = await useCase();

      expect(result, isA<SuccessBaseResponse<AllVehiclesResponseEntity>>());
      expect(
        (result as SuccessBaseResponse<AllVehiclesResponseEntity>).data,
        tResponse,
      );
      verify(mockRepo.getVehicles()).called(1);
    });

    test('should propagate error from repo', () async {
      final tFailure = Failure(message: "Failed to load vehicles");
      when(mockRepo.getVehicles()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<AllVehiclesResponseEntity>(failure: tFailure),
      );

      final result = await useCase();

      expect(result, isA<ErrorBaseResponse<AllVehiclesResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<AllVehiclesResponseEntity>).failure.message,
        "Failed to load vehicles",
      );
      verify(mockRepo.getVehicles()).called(1);
    });
  });
}

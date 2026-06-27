import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data_use_case.dart';

import 'get_driver_data_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  late GetDriverDataUseCase useCase;
  late MockProfileRepo mockRepo;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileDataResponseEntity>>(
      SuccessBaseResponse<ProfileDataResponseEntity>(
        data: const ProfileDataResponseEntity(),
      ),
    );
  });

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = GetDriverDataUseCase(profileRepo: mockRepo);
  });

  group('GetDriverDataUseCase', () {
    final tDriver = const ProfileDriverEntity(
      id: "1",
      firstName: "John",
      lastName: "Doe",
    );
    final tResponse = ProfileDataResponseEntity(
      message: "success",
      driver: tDriver,
    );

    test('should return success response from repo', () async {
      when(mockRepo.getProfileData()).thenAnswer(
        (_) async =>
            SuccessBaseResponse<ProfileDataResponseEntity>(data: tResponse),
      );

      final result = await useCase();

      expect(result, isA<SuccessBaseResponse<ProfileDataResponseEntity>>());
      expect(
        (result as SuccessBaseResponse<ProfileDataResponseEntity>).data,
        tResponse,
      );
      verify(mockRepo.getProfileData()).called(1);
    });

    test('should propagate error from repo', () async {
      final tFailure = Failure(message: "Failed to load driver data");
      when(mockRepo.getProfileData()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<ProfileDataResponseEntity>(failure: tFailure),
      );

      final result = await useCase();

      expect(result, isA<ErrorBaseResponse<ProfileDataResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<ProfileDataResponseEntity>).failure.message,
        "Failed to load driver data",
      );
      verify(mockRepo.getProfileData()).called(1);
    });
  });
}

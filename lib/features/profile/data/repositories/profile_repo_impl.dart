import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSourceContract profileRemoteDataSourceContract;

  ProfileRepoImpl({required this.profileRemoteDataSourceContract});

  @override
  Future<BaseResponse<ProfileDataResponseEntity>> getProfileData() async {
    final response = await profileRemoteDataSourceContract.getProfileData();
    return switch (response) {
      SuccessBaseResponse<ProfileDataResponseDto>(:final data) =>
        SuccessBaseResponse(data: data.toEntity()),
      ErrorBaseResponse<ProfileDataResponseDto>(:final failure) =>
        ErrorBaseResponse(failure: failure),
    };
  }

  @override
  Future<BaseResponse<AllVehiclesResponseEntity>> getVehicles() async {
    final response = await profileRemoteDataSourceContract.getVehicles();
    return switch (response) {
      SuccessBaseResponse<AllVehiclesResponseDto>(:final data) =>
        SuccessBaseResponse(data: data.toEntity()),
      ErrorBaseResponse<AllVehiclesResponseDto>(:final failure) =>
        ErrorBaseResponse(failure: failure),
    };
  }
}

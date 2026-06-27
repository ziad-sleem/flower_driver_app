import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:tracking_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';

@LazySingleton(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;
  final SafeApiCaller safeApiCaller;

  ProfileRemoteDataSourceImpl({
    required this.profileApiClient,
    required this.safeApiCaller,
  });

  @override
  Future<BaseResponse<ProfileDataResponseDto>> getProfileData() async {
    return safeApiCaller.safeCall(() => profileApiClient.getProfileData());
  }

  @override
  Future<BaseResponse<AllVehiclesResponseDto>> getVehicles() async {
    return safeApiCaller.safeCall(() => profileApiClient.getVehicles());
  }
}

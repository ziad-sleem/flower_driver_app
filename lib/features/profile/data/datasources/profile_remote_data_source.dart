import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/data/models/requests/reset_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/reset_password_response_dto.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<BaseResponse<ProfileDataResponseDto>> getProfileData();
  Future<BaseResponse<AllVehiclesResponseDto>> getVehicles();
  Future<BaseResponse<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  );
}

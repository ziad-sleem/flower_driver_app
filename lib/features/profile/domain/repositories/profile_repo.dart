import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';

abstract interface class ProfileRepo {
  Future<BaseResponse<ProfileDataResponseEntity>> getProfileData();
  Future<BaseResponse<AllVehiclesResponseEntity>> getVehicles();
  Future<BaseResponse<ResetPasswordResponseEntity>> resetPassword({
    required String password,
    required String newPassword,
  });
}

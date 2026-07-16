import 'dart:io';

import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/update_vehicle_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

abstract interface class ProfileRepo {
  Future<BaseResponse<ProfileDataResponseEntity>> getProfileData();
  Future<BaseResponse<AllVehiclesResponseEntity>> getVehicles();
  Future<BaseResponse<ResetPasswordResponseEntity>> resetPassword({
    required String password,
    required String newPassword,
  });
  Future<BaseResponse<ProfileDriverEntity>> editProfile(
    EditProfileParams params,
  );
  Future<BaseResponse<void>> uploadPhoto(File photo);
  Future<BaseResponse<UpdateVehicleResponseEntity>> updateVehicle(
    EditVehicleParams params,
  );
}

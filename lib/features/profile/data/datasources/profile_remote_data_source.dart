import 'dart:io';

import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/requests/reset_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/reset_password_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/update_vehicle_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<BaseResponse<ProfileDataResponseDto>> getProfileData();
  Future<BaseResponse<AllVehiclesResponseDto>> getVehicles();
  Future<BaseResponse<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  );
  Future<BaseResponse<ProfileDriverEntity>> editProfile(
    EditProfileParams params,
  );
  Future<BaseResponse<void>> uploadPhoto(File photo);
  Future<BaseResponse<UpdateVehicleResponseDto>> updateVehicle(
    EditVehicleParams params,
  );
}

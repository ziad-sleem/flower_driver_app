import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:tracking_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/requests/reset_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/reset_password_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/update_vehicle_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/edit_vehicle_params.dart';

@LazySingleton(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;
  final SafeApiCaller safeApiCaller;

  ProfileRemoteDataSourceImpl({
    required this.profileApiClient,
    required this.safeApiCaller,
  });

  @override
  Future<BaseResponse<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  ) {
    return safeApiCaller.safeCall(() => profileApiClient.resetPassword(request));
  }

  @override
  Future<BaseResponse<ProfileDataResponseDto>> getProfileData() async {
    return safeApiCaller.safeCall(() => profileApiClient.getProfileData());
  }

  @override
  Future<BaseResponse<AllVehiclesResponseDto>> getVehicles() async {
    return safeApiCaller.safeCall(() => profileApiClient.getVehicles());
  }

  @override
  Future<BaseResponse<ProfileDriverEntity>> editProfile(
    EditProfileParams params,
  ) async {
    try {
      final response = await profileApiClient.editProfile(
        EditProfileJsonRequest(
          firstName: params.firstName.trim(),
          lastName: params.lastName.trim(),
          email: params.email.trim(),
          phone: params.phone.trim(),
        ),
      );
      final driver = response.driver;
      if (driver != null) {
        return SuccessBaseResponse(data: driver.toEntity());
      }
      return ErrorBaseResponse(
        failure: ErrorHandler.handle(response.message ?? 'Update failed'),
      );
    } catch (e) {
      return ErrorBaseResponse(failure: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) async {
    try {
      await profileApiClient.uploadPhoto(photo);
      return SuccessBaseResponse(data: null);
    } catch (e) {
      return ErrorBaseResponse(failure: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<UpdateVehicleResponseDto>> updateVehicle(
    EditVehicleParams params,
  ) async {
    final formMap = <String, dynamic>{
      'vehicleType': params.vehicleType,
      'vehicleNumber': params.vehicleNumber,
    };

    if (params.vehicleLicensePath != null) {
      formMap['vehicleLicense'] = await MultipartFile.fromFile(
        params.vehicleLicensePath!,
        filename: params.vehicleLicensePath!.split('/').last,
      );
    }

    return safeApiCaller.safeCall(
      () => profileApiClient.updateVehicleInfo(FormData.fromMap(formMap)),
    );
  }
}

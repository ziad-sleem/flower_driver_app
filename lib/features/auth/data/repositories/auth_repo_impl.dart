import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/model/user.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_now_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/driver_profile_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_response_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/driver_profile_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSourceContract authRemoteDataSourceContract;

  AuthRepoImpl({required this.authRemoteDataSourceContract});

  @override
  Future<BaseResponse<UserEntity>> login(LoginParams params) async {
    final response = await authRemoteDataSourceContract.login(params);

    switch (response) {
      case SuccessBaseResponse<UserDto>():
        final profileResponse = await authRemoteDataSourceContract
            .getDriverProfile();

        switch (profileResponse) {
          case SuccessBaseResponse<DriverProfileResponseDto>():
            final driverId = profileResponse.data.driver?.id;

            if (driverId != null && driverId.isNotEmpty) {
              await SecureStorageService.saveDriverId(driverId);
            }

          case ErrorBaseResponse():
            break;
        }

        return SuccessBaseResponse<UserEntity>(data: response.data.toDomain());

      case ErrorBaseResponse<UserDto>():
        return ErrorBaseResponse<UserEntity>(failure: response.failure);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required String email,
  }) async {
    final response = await authRemoteDataSourceContract.forgetPassword(
      email: email,
    );
    return switch (response) {
      SuccessBaseResponse() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse() => ErrorBaseResponse(failure: response.failure),
    };
  }

  @override
  Future<BaseResponse<VerifyResetCodeEntity>> verifyResetCode({
    required String resetCode,
  }) async {
    final response = await authRemoteDataSourceContract.verifyResetCode(
      resetCode: resetCode,
    );
    return switch (response) {
      SuccessBaseResponse() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse() => ErrorBaseResponse(failure: response.failure),
    };
  }

  @override
  Future<BaseResponse<ResetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await authRemoteDataSourceContract.resetPassword(
      email: email,
      newPassword: newPassword,
    );
    return switch (response) {
      SuccessBaseResponse() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse() => ErrorBaseResponse(failure: response.failure),
    };
  }

  @override
  Future<BaseResponse<ApplyNowResponseEntity>> applyNow(
    ApplyNowParams params,
  ) async {
    final vehicleLicense = await MultipartFile.fromFile(
      params.vehicleLicensePath,
      filename: params.vehicleLicensePath.split('/').last,
    );

    final nidImg = await MultipartFile.fromFile(
      params.nidImgPath,
      filename: params.nidImgPath.split('/').last,
    );

    final request = FormData.fromMap({
      'country': params.country,
      'firstName': params.firstName,
      'lastName': params.lastName,
      'vehicleType': params.vehicleType,
      'vehicleNumber': params.vehicleNumber,
      'NID': params.nid,
      'email': params.email,
      'password': params.password,
      'rePassword': params.rePassword,
      'gender': params.gender,
      'phone': params.phone,
      'vehicleLicense': vehicleLicense,
      'NIDImg': nidImg,
    });

    final result = await authRemoteDataSourceContract.applyNow(request);

    switch (result) {
      case SuccessBaseResponse<ApplyNowResponseDto>():
        await SecureStorageService.saveToken(result.data.token ?? '');
        return SuccessBaseResponse<ApplyNowResponseEntity>(
          data: result.data.toEntity(),
        );

      case ErrorBaseResponse():
        return ErrorBaseResponse(failure: result.failure);
    }
  }

  @override
  Future<BaseResponse<VehicleResponseEntity>> getVehicles() async {
    final response = await authRemoteDataSourceContract.getVehicles();

    switch (response) {
      case SuccessBaseResponse<VehicleResponseDto>():
        return SuccessBaseResponse<VehicleResponseEntity>(
          data: response.data.toEntity(),
        );

      case ErrorBaseResponse():
        return ErrorBaseResponse(failure: response.failure);
    }
  }

  @override
  Future<BaseResponse<DriverProfileResponseEntity>> getDriverProfile() async {
    final response = await authRemoteDataSourceContract.getDriverProfile();

    switch (response) {
      case SuccessBaseResponse<DriverProfileResponseDto>():
        return SuccessBaseResponse(data: response.data.toEntity());

      case ErrorBaseResponse<DriverProfileResponseDto>():
        return ErrorBaseResponse(failure: response.failure);
    }
  }
}

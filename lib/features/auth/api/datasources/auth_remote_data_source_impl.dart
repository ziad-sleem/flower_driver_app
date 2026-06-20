import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_now_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/forget_password_response.dart';
import 'package:tracking_app/features/auth/data/models/response/reset_password_response.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/verify_reset_code_response.dart';

@LazySingleton(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient authApiClient;
  final SafeApiCaller safeApiCaller;
  AuthRemoteDataSourceImpl({
    required this.authApiClient,
    required this.safeApiCaller,
  });

  static const _fakeDelay = Duration(milliseconds: 500);

  @override
  Future<BaseResponse<ForgetPasswordResponseDto>> forgetPassword({
    required String email,
  }) async {
    await Future.delayed(_fakeDelay);
    return SuccessBaseResponse(
      data: ForgetPasswordResponseDto(
        message: 'Code sent (static)',
        info: 'check email (static)',
      ),
    );
  }

  @override
  Future<BaseResponse<VerifyResetCodeResponseDto>> verifyResetCode({
    required String resetCode,
  }) async {
    await Future.delayed(_fakeDelay);
    final ok = resetCode == '1234';
    return SuccessBaseResponse(
      data: VerifyResetCodeResponseDto(status: ok ? 'Success' : 'Fail'),
    );
  }

  @override
  Future<BaseResponse<ResetPasswordResponseDto>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(_fakeDelay);
    return SuccessBaseResponse(
      data: ResetPasswordResponseDto(
        message: 'Password reset (static)',
        token: 'fake-token',
      ),
    );
  }

  @override
  Future<BaseResponse<VehicleResponseDto>> getVehicles() {
    return safeApiCaller.safeCall(() => authApiClient.getVehicles());
  }

  @override
  Future<BaseResponse<ApplyNowResponseDto>> applyNow(FormData request) {
    return safeApiCaller.safeCall(() => authApiClient.applyNow(request));
  }
}

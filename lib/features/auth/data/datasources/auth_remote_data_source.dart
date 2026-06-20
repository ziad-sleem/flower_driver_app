import 'package:dio/dio.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_now_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/forget_password_response.dart';
import 'package:tracking_app/features/auth/data/models/response/reset_password_response.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/verify_reset_code_response.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<ForgetPasswordResponseDto>> forgetPassword({
    required String email,
  });

  Future<BaseResponse<VerifyResetCodeResponseDto>> verifyResetCode({
    required String resetCode,
  });

  Future<BaseResponse<ResetPasswordResponseDto>> resetPassword({
    required String email,
    required String newPassword,
  });
  Future<BaseResponse<ApplyNowResponseDto>> applyNow(FormData request);
  Future<BaseResponse<VehicleResponseDto>> getVehicles();
}

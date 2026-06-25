import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/driver_profile_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<UserEntity>> login(LoginParams params);

  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required String email,
  });

  Future<BaseResponse<VerifyResetCodeEntity>> verifyResetCode({
    required String resetCode,
  });

  Future<BaseResponse<ResetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<BaseResponse<ApplyNowResponseEntity>> applyNow(ApplyNowParams params);
  Future<BaseResponse<VehicleResponseEntity>> getVehicles();
  Future<BaseResponse<DriverProfileResponseEntity>> getDriverProfile();
}

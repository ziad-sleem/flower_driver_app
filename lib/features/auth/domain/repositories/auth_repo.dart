import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';

abstract interface class AuthRepo {
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
}

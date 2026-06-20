import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSourceContract authRemoteDataSourceContract;

  AuthRepoImpl({required this.authRemoteDataSourceContract});

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
}

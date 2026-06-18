import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/localization_constants/error_massage_constants.dart';
import 'package:tracking_app/core/network/model/user.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/requests/login_request.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

@LazySingleton(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient authApiClient;

  AuthRemoteDataSourceImpl({required this.authApiClient});

  @override
  Future<BaseResponse<UserDto>> login(LoginParams params) async {
    try {
      final response = await authApiClient.login(
        LoginRequest(email: params.email, password: params.password),
      );

      if (response.token != null && response.token!.isNotEmpty) {
        await SecureStorageService.saveToken(response.token!);
        return SuccessBaseResponse<UserDto>(data: UserDto());
      }

      return ErrorBaseResponse<UserDto>(
        failure: Failure(
          message: response.message ?? ErrorConstants.loginError,
        ),
      );
    } catch (e) {
      return ErrorBaseResponse<UserDto>(failure: ErrorHandler.handle(e));
    }
  }
}

import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/model/user.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

abstract class AuthRemoteDataSourceContract {
  Future<BaseResponse<UserDto>> login(LoginParams params);
}

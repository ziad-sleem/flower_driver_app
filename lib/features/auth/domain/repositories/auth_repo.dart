import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

abstract class AuthRepo {
  Future<BaseResponse<UserEntity>> login(LoginParams params);
}

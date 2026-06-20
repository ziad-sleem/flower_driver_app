import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase({required this.authRepo});

  Future<BaseResponse<UserEntity>> call(LoginParams params) {
    return authRepo.login(params);
  }
}

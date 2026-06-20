import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepo _repo;

  ForgetPasswordUseCase(this._repo);

  Future<BaseResponse<ForgetPasswordEntity>> call({required String email}) {
    return _repo.forgetPassword(email: email);
  }
}

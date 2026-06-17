import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepo _repo;

  ResetPasswordUseCase(this._repo);

  Future<BaseResponse<ResetPasswordEntity>> call({
    required String email,
    required String newPassword,
  }) {
    return _repo.resetPassword(email: email, newPassword: newPassword);
  }
}

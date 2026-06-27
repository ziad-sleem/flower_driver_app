import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@injectable
class ResetPasswordUseCase {
  final ProfileRepo _repo;

  ResetPasswordUseCase(this._repo);

  Future<BaseResponse<ResetPasswordResponseEntity>> call({
    required String password,
    required String newPassword,
  }) {
    return _repo.resetPassword(password: password, newPassword: newPassword);
  }
}

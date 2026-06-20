import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@injectable
class VerifyResetCodeUseCase {
  final AuthRepo _repo;

  VerifyResetCodeUseCase(this._repo);

  Future<BaseResponse<VerifyResetCodeEntity>> call({
    required String resetCode,
  }) {
    return _repo.verifyResetCode(resetCode: resetCode);
  }
}

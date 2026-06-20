import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@injectable
class ApplyNowUseCase {
  final AuthRepo repository;

  ApplyNowUseCase(this.repository);

  Future<BaseResponse<ApplyNowResponseEntity>> call(ApplyNowParams params) {
    return repository.applyNow(params);
  }
}

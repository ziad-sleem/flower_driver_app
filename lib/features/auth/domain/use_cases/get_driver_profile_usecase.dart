import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/driver_profile_response_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@injectable
class GetDriverProfileUseCase {
  final AuthRepo repo;

  GetDriverProfileUseCase(this.repo);

  Future<BaseResponse<DriverProfileResponseEntity>> call() {
    return repo.getDriverProfile();
  }
}

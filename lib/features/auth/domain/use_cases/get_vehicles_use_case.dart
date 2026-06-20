import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@injectable
class GetVehiclesUseCase {
  final AuthRepo repository;

  GetVehiclesUseCase(this.repository);

  Future<BaseResponse<VehicleResponseEntity>>
      call() {
    return repository.getVehicles();
  }
}
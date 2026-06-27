import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/vehicles_response_entity.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/repositories/edit_vehicle_info_repo.dart';

@injectable
class GetVehiclesUseCase {
  final EditVehicleInfoRepo repository;

  GetVehiclesUseCase(this.repository);

  Future<BaseResponse<VehiclesResponseEntity>> call() {
    return repository.getVehicles();
  }
}

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/update_vehicle_response_entity.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/repositories/edit_vehicle_info_repo.dart';

@injectable
class UpdateVehicleUseCase {
  final EditVehicleInfoRepo repository;

  UpdateVehicleUseCase(this.repository);

  Future<BaseResponse<UpdateVehicleResponseEntity>> call(
    EditVehicleParams params,
  ) {
    return repository.updateVehicle(params);
  }
}

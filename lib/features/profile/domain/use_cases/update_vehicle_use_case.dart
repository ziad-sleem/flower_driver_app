import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/entities/update_vehicle_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@injectable
class UpdateVehicleUseCase {
  final ProfileRepo _repository;

  UpdateVehicleUseCase(this._repository);

  Future<BaseResponse<UpdateVehicleResponseEntity>> call(
    EditVehicleParams params,
  ) {
    return _repository.updateVehicle(params);
  }
}

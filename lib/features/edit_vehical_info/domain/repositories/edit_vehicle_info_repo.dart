import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/update_vehicle_response_entity.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/vehicles_response_entity.dart';

abstract interface class EditVehicleInfoRepo {
  Future<BaseResponse<VehiclesResponseEntity>> getVehicles();

  Future<BaseResponse<UpdateVehicleResponseEntity>> updateVehicle(
    EditVehicleParams params,
  );
}

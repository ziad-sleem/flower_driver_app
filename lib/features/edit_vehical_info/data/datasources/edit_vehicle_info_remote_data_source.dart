import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/update_vehicle_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/vehicles_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/edit_vehicle_params.dart';

abstract class EditVehicleInfoRemoteDataSourceContract {
  Future<BaseResponse<VehiclesResponseDto>> getVehicles();

  Future<BaseResponse<UpdateVehicleResponseDto>> updateVehicle(
    EditVehicleParams params,
  );
}

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_vehical_info/data/datasources/edit_vehicle_info_remote_data_source.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/update_vehicle_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/vehicles_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/update_vehicle_response_entity.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/vehicles_response_entity.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/repositories/edit_vehicle_info_repo.dart';

@Injectable(as: EditVehicleInfoRepo)
class EditVehicleInfoRepoImpl implements EditVehicleInfoRepo {
  final EditVehicleInfoRemoteDataSourceContract remoteDataSource;

  EditVehicleInfoRepoImpl({required this.remoteDataSource});

  @override
  Future<BaseResponse<VehiclesResponseEntity>> getVehicles() async {
    final response = await remoteDataSource.getVehicles();
    return switch (response) {
      SuccessBaseResponse<VehiclesResponseDto>() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse<VehiclesResponseDto>() => ErrorBaseResponse(
        failure: response.failure,
      ),
    };
  }

  @override
  Future<BaseResponse<UpdateVehicleResponseEntity>> updateVehicle(
    EditVehicleParams params,
  ) async {
    final response = await remoteDataSource.updateVehicle(params);
    return switch (response) {
      SuccessBaseResponse<UpdateVehicleResponseDto>() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse<UpdateVehicleResponseDto>() => ErrorBaseResponse(
        failure: response.failure,
      ),
    };
  }
}

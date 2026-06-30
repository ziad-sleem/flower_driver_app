import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/edit_vehical_info/api/api_client/edit_vehicle_info_api_client.dart';
import 'package:tracking_app/features/edit_vehical_info/data/datasources/edit_vehicle_info_remote_data_source.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/update_vehicle_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/vehicles_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/edit_vehicle_params.dart';

@LazySingleton(as: EditVehicleInfoRemoteDataSourceContract)
class EditVehicleInfoRemoteDataSourceImpl
    implements EditVehicleInfoRemoteDataSourceContract {
  final EditVehicleInfoApiClient apiClient;
  final SafeApiCaller safeApiCaller;

  EditVehicleInfoRemoteDataSourceImpl({
    required this.apiClient,
    required this.safeApiCaller,
  });

  @override
  Future<BaseResponse<VehiclesResponseDto>> getVehicles() {
    return safeApiCaller.safeCall(() => apiClient.getVehicles());
  }

  @override
  Future<BaseResponse<UpdateVehicleResponseDto>> updateVehicle(
    EditVehicleParams params,
  ) async {
    final formMap = <String, dynamic>{
      'vehicleType': params.vehicleType,
      'vehicleNumber': params.vehicleNumber,
    };

    if (params.vehicleLicensePath != null) {
      formMap['vehicleLicense'] = await MultipartFile.fromFile(
        params.vehicleLicensePath!,
        filename: params.vehicleLicensePath!.split('/').last,
      );
    }

    return safeApiCaller.safeCall(
      () => apiClient.updateVehicleInfo(FormData.fromMap(formMap)),
    );
  }
}

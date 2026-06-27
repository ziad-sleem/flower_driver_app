import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/update_vehicle_response_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/responses/vehicles_response_dto.dart';

part 'edit_vehicle_info_api_client.g.dart';

@RestApi()
abstract interface class EditVehicleInfoApiClient {
  @factoryMethod
  factory EditVehicleInfoApiClient(Dio dio, {String baseUrl}) =
      _EditVehicleInfoApiClient;

  @GET(EditVehicleInfoEndPoint.vehicles)
  Future<VehiclesResponseDto> getVehicles();

  @PUT(EditVehicleInfoEndPoint.updateVehicleInfo)
  @MultiPart()
  Future<UpdateVehicleResponseDto> updateVehicleInfo(@Body() FormData request);
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/auth/data/models/requests/login_request.dart';
import 'package:tracking_app/features/auth/data/models/response/driver_profile_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/login_response.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_now_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_response_dto.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract interface class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST(AuthEndPoint.signIn)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(AuthEndPoint.applyNow)
  @MultiPart()
  Future<ApplyNowResponseDto> applyNow(@Body() FormData request);

  @GET(AuthEndPoint.vehicles)
  Future<VehicleResponseDto> getVehicles();
  @GET("/api/v1/drivers/profile-data")
  Future<DriverProfileResponseDto> getDriverProfile();
}

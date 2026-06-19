import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_now_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_response_dto.dart';

@LazySingleton(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient authApiClient;
  final SafeApiCaller safeApiCaller;
  AuthRemoteDataSourceImpl({
    required this.authApiClient,
    required this.safeApiCaller,
  });
  @override
  Future<BaseResponse<ApplyNowResponseDto>> applyNow(FormData request) {
    return safeApiCaller.safeCall(() => authApiClient.applyNow(request));
  }

  @override
  Future<BaseResponse<VehicleResponseDto>> getVehicles() {
    return safeApiCaller.safeCall(() => authApiClient.getVehicles());
  }
}

import 'package:dio/dio.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_now_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_response_dto.dart';

abstract class AuthRemoteDataSourceContract {
  Future<BaseResponse<ApplyNowResponseDto>> applyNow(FormData request);
  Future<BaseResponse<VehicleResponseDto>> getVehicles();
}

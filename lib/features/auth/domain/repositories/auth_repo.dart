import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';

abstract class AuthRepo {
  Future<BaseResponse<ApplyNowResponseEntity>> applyNow(ApplyNowParams params);
  Future<BaseResponse<VehicleResponseEntity>> getVehicles();
}

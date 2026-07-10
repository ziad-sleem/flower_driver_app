import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data_use_case.dart';

@injectable
class UpdateOrderStateUseCase {
  final OrderDetailsRepo repo;
  final GetDriverDataUseCase _getDriverDataUseCase;

  UpdateOrderStateUseCase({
    required this.repo,
    required GetDriverDataUseCase getDriverDataUseCase,
  }) : _getDriverDataUseCase = getDriverDataUseCase;

  Future<BaseResponse<UpdateOrderStateResponseEntity>> call(
    UpdateOrderStateParams params,
  ) async {
    final response = await repo.updateOrderState(params);

    if (response is SuccessBaseResponse<UpdateOrderStateResponseEntity>) {
      final driverId = await SecureStorageService.getDriverId();
      try {
        if (params.state == "inProgress") {
          String? driverName;
          String? driverPhone;
          String? vehicleType;
          String? vehicleNumber;
          String? vehicleLicense;

          final profileResult = await _getDriverDataUseCase();
          if (profileResult is SuccessBaseResponse<ProfileDataResponseEntity>) {
            final driver = profileResult.data.driver;
            driverName = driver?.name;
            driverPhone = driver?.phone;
            vehicleType = driver?.vehicleType;
            vehicleNumber = driver?.vehicleNumber;
            vehicleLicense = driver?.vehicleLicense;
          }

          await repo.saveCurrentOrder(
            order: params.order,
            state: params.state,
            driverRequestedDelivery: false,
            driverId: driverId,
            driverName: driverName,
            driverPhone: driverPhone,
            vehicleType: vehicleType,
            vehicleNumber: vehicleNumber,
            vehicleLicense: vehicleLicense,
          );
        } else if (params.state == "canceled") {
          await repo.deleteCurrentOrder(orderId: params.orderId);
        }
      } catch (error) {
        debugPrint('Current order sync failed: $error');
      }
    }

    return response;
  }
}

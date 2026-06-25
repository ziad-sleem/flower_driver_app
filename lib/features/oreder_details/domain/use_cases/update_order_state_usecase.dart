import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class UpdateOrderStateUseCase {
  final OrderDetailsRepo repo;

  UpdateOrderStateUseCase({required this.repo});

  Future<BaseResponse<UpdateOrderStateResponseEntity>> call(
    UpdateOrderStateParams params,
  ) async {
    final response = await repo.updateOrderState(params);

    if (response is SuccessBaseResponse<UpdateOrderStateResponseEntity>) {
      final driverId = await SecureStorageService.getDriverId();
      print("Driver ID => $driverId");
      if (driverId != null) {
        if (params.state == "inProgress") {
          await repo.saveCurrentOrder(
            driverId: driverId,
            orderId: params.orderId,
            state: params.state,
          );
        } else if (params.state == "canceled") {
          await repo.deleteCurrentOrder(driverId: driverId);
        }
      }
    }

    return response;
  }
}

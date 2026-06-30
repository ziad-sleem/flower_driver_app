import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';

abstract interface class OrderDetailsRepo {
  Future<BaseResponse<OrdersResponseEntity>> getAllPendingOrders();

  Future<BaseResponse<UpdateOrderStateResponseEntity>> updateOrderState(
    UpdateOrderStateParams params,
  );
  Future<void> saveCurrentOrder({
    required String driverId,
    required String orderId,
    required String state,
  });

  Future<void> deleteCurrentOrder({required String driverId});

  Stream<String?> watchOrderState({required String driverId});
}

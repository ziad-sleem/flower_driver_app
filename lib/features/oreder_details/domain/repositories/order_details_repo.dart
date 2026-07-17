import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';

abstract class OrderDetailsRepo {
  Future<BaseResponse<OrdersResponseEntity>> getAllPendingOrders({
    required int page,
    required int limit,
  });
  Future<BaseResponse<UpdateOrderStateResponseEntity>> updateOrderState(
    UpdateOrderStateParams params,
  );

  Future<void> saveCurrentOrder({
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  });

  Future<void> deleteCurrentOrder({required String orderId});

  Stream<CurrentOrderEntity?> watchCurrentOrder({required String orderId});

  Future<CurrentOrderEntity?> getCurrentOrder({required String orderId});

  Future<void> createNotificationRequest({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  });

  Future<void> setDriverLocation({
    required String orderId,
    required double latitude,
    required double longitude,
  });

  Future<void> deleteDriverLocation({required String orderId});
}

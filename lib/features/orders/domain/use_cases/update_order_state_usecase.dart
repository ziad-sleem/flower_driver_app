import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/orders/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/orders/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_details_repo.dart';
import 'package:tracking_app/features/orders/domain/use_cases/create_notification_request_use_case.dart';

@injectable
class UpdateOrderStateUseCase {
  final OrderDetailsRepo repo;
  final CreateNotificationRequestUseCase createNotificationRequestUseCase;

  UpdateOrderStateUseCase({
    required this.repo,
    required this.createNotificationRequestUseCase,
  });

  Future<BaseResponse<UpdateOrderStateResponseEntity>> call(
    UpdateOrderStateParams params,
  ) async {
    final response = await repo.updateOrderState(params);

    if (response is SuccessBaseResponse<UpdateOrderStateResponseEntity>) {
      final driverId = await SecureStorageService.getDriverId();
      try {
        if (driverId != null && driverId.isNotEmpty) {
          if (params.state == "inProgress") {
            await repo.saveCurrentOrder(
              driverId: driverId,
              order: params.order,
              state: params.state,
              driverRequestedDelivery: false,
            );

            await createNotificationRequestUseCase(
              userId: params.order.user!.id!,
              orderId: params.order.id!,
              title: "Order Accepted",
              body: "Your order has been accepted by the driver.",
              type: "order_accepted",
            );
          } else if (params.state == "completed") {
            final historyOrder = OrderEntity(
              id: params.order.id,
              user: params.order.user,
              orderItems: params.order.orderItems,
              totalPrice: params.order.totalPrice,
              paymentType: params.order.paymentType,
              isPaid: params.order.isPaid,
              isDelivered: params.order.isDelivered,
              state: OrderState.completed,
              createdAt: params.order.createdAt,
              updatedAt: params.order.updatedAt,
              orderNumber: params.order.orderNumber,
              v: params.order.v,
              store: params.order.store,
              shippingAddress: params.order.shippingAddress,
              paidAt: params.order.paidAt,
            );
            await repo.saveOrderHistory(
              order: historyOrder,
              state: params.state,
              driverId: driverId,
            );
            await repo.deleteCurrentOrder(orderId: params.order.id!);

            await createNotificationRequestUseCase(
              userId: params.order.user!.id!,
              orderId: params.order.id!,
              title: "Order Delivered",
              body: "Your order has been delivered successfully.",
              type: "order_completed",
            );
          } else if (params.state == "canceled") {
            final historyOrder = OrderEntity(
              id: params.order.id,
              user: params.order.user,
              orderItems: params.order.orderItems,
              totalPrice: params.order.totalPrice,
              paymentType: params.order.paymentType,
              isPaid: params.order.isPaid,
              isDelivered: params.order.isDelivered,
              state: OrderState.canceled,
              createdAt: params.order.createdAt,
              updatedAt: params.order.updatedAt,
              orderNumber: params.order.orderNumber,
              v: params.order.v,
              store: params.order.store,
              shippingAddress: params.order.shippingAddress,
              paidAt: params.order.paidAt,
            );
            await repo.saveOrderHistory(
              order: historyOrder,
              state: params.state,
              driverId: driverId,
            );
            await repo.deleteCurrentOrder(orderId: params.order.id!);

            await createNotificationRequestUseCase(
              userId: params.order.user!.id!,
              orderId: params.order.id!,
              title: "Order Cancelled",
              body: "Your order has been cancelled.",
              type: "order_cancelled",
            );
          }
        }
      } catch (error) {
        debugPrint("Current order sync failed: $error");
      }
    }

    return response;
  }
}

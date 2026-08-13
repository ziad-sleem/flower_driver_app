import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/data/models/order_details_response_dto.dart';
import 'package:tracking_app/features/orders/data/models/request/update_order_state_request_dto.dart';
import 'package:tracking_app/features/orders/data/models/update_order_state_response_dto.dart';

abstract interface class OrderDetailsRemoteDataSource {
  Future<BaseResponse<OrdersResponseDto>> getAllPendingOrders({
    required int page,
    required int limit,
  });
  Future<BaseResponse<UpdateOrderStateResponseDto>> updateOrderState({
    required String orderId,
    required UpdateOrderStateRequestDto request,
  });
}

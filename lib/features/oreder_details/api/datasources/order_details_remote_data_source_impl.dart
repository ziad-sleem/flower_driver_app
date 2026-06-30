import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/oreder_details/api/api_client/order_details_api_client.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_remote_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_details_response_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/request/update_order_state_request_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/update_order_state_response_dto.dart';

@Injectable(as: OrderDetailsRemoteDataSource)
class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  final SafeApiCaller safeApiCaller;
  final OrderDetailsApiClient apiClient;
  OrderDetailsRemoteDataSourceImpl({
    required this.safeApiCaller,
    required this.apiClient,
  });

  @override
  Future<BaseResponse<OrdersResponseDto>> getAllPendingOrders({
    required int page,
    required int limit,
  }) async {
    return await safeApiCaller.safeCall(() async {
      return await apiClient.getAllPendingOrders(page, limit);
    });
  }

  @override
  Future<BaseResponse<UpdateOrderStateResponseDto>> updateOrderState({
    required String orderId,
    required UpdateOrderStateRequestDto request,
  }) async {
    return await safeApiCaller.safeCall(
      () => apiClient.updateOrderState(orderId, request),
    );
  }
}

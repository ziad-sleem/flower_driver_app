import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/orders/order_page/api/api_client/order_page_api_client.dart';
import 'package:tracking_app/features/orders/order_page/data/datasources/order_page_remote_data_source.dart';
import 'package:tracking_app/features/orders/order_page/data/models/driver_orders_response_dto.dart';

@LazySingleton(as: OrderPageRemoteDataSourceContract)
class OrderPageRemoteDataSourceImpl implements OrderPageRemoteDataSourceContract {
  final OrderPageApiClient apiClient;
  final SafeApiCaller safeApiCaller;

  OrderPageRemoteDataSourceImpl({
    required this.apiClient,
    required this.safeApiCaller,
  });

  @override
  Future<BaseResponse<DriverOrdersResponseDto>> getDriverOrders({
    required int page,
    required int limit,
  }) {
    return safeApiCaller.safeCall(() => apiClient.getDriverOrders(page, limit));
  }
}

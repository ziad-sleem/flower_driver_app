import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/data/models/driver_orders_response_dto.dart';

abstract interface class OrderPageRemoteDataSourceContract {
  Future<BaseResponse<DriverOrdersResponseDto>> getDriverOrders({
    required int page,
    required int limit,
  });
}

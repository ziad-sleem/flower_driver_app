import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_orders_response_entity.dart';

abstract interface class OrderPageRepo {
  Future<BaseResponse<DriverOrdersResponseEntity>> getDriverOrders({
    required int page,
    required int limit,
  });
}

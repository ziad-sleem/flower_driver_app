import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/orders/order_page/data/models/driver_orders_response_dto.dart';

part 'order_page_api_client.g.dart';

@RestApi()
abstract interface class OrderPageApiClient {
  @factoryMethod
  factory OrderPageApiClient(Dio dio, {String baseUrl}) = _OrderPageApiClient;

  @GET(OrdersEndPoints.getDriverOrders)
  Future<DriverOrdersResponseDto> getDriverOrders(
    @Query("page") int page,
    @Query("limit") int limit,
  );
}

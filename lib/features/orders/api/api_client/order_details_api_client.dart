import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/orders/data/models/order_details_response_dto.dart';
import 'package:tracking_app/features/orders/data/models/request/update_order_state_request_dto.dart';
import 'package:tracking_app/features/orders/data/models/update_order_state_response_dto.dart';

part 'order_details_api_client.g.dart';

@RestApi()
abstract interface class OrderDetailsApiClient {
  @factoryMethod
  factory OrderDetailsApiClient(Dio dio, {String baseUrl}) =
      _OrderDetailsApiClient;

  @GET(OrdersEndPoints.getPendingOrder)
  Future<OrdersResponseDto> getAllPendingOrders(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @PUT("${OrdersEndPoints.updateOrderState}/{orderId}")
  Future<UpdateOrderStateResponseDto> updateOrderState(
    @Path("orderId") String orderId,
    @Body() UpdateOrderStateRequestDto request,
  );
}

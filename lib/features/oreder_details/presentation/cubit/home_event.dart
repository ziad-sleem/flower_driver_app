import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

sealed class HomeEvent {}

class GetPendingOrders extends HomeEvent {}

class AcceptOrder extends HomeEvent {
  final OrderEntity order;

  AcceptOrder({required this.order});
}

class RejectOrder extends HomeEvent {
  final String orderId;

  RejectOrder({required this.orderId});
}

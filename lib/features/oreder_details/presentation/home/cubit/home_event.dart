import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class GetPendingOrders extends HomeEvent {
  const GetPendingOrders();
}

class CheckCurrentOrder extends HomeEvent {
  const CheckCurrentOrder();
}

class AcceptOrder extends HomeEvent {
  final OrderEntity order;

  const AcceptOrder({required this.order});
}

class RejectOrder extends HomeEvent {
  final OrderEntity order;

  const RejectOrder({required this.order});
}

class LoadMoreOrders extends HomeEvent {
  const LoadMoreOrders();
}

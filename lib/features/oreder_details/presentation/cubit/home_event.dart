sealed class HomeEvent {}

class GetPendingOrders extends HomeEvent {}

class AcceptOrder extends HomeEvent {
  final String orderId;

  AcceptOrder({required this.orderId});
}

class RejectOrder extends HomeEvent {
  final String orderId;

  RejectOrder({required this.orderId});
}

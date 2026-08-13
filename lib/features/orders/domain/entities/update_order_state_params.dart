import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';

class UpdateOrderStateParams {
  final OrderEntity order;
  final String state;

  const UpdateOrderStateParams({required this.order, required this.state});

  String get orderId => order.id ?? '';
}

import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';

class OrderDetailsArgs {
  final OrderEntity order;
  final String? state;

  const OrderDetailsArgs({required this.order, this.state});
}

import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';

sealed class OrderDetailsIntent {
  const OrderDetailsIntent();
}

class StartOrderDetailsIntent extends OrderDetailsIntent {
  final OrderEntity order;
  final String? initialState;

  const StartOrderDetailsIntent({required this.order, this.initialState});
}

class AdvanceOrderStepIntent extends OrderDetailsIntent {
  const AdvanceOrderStepIntent();
}

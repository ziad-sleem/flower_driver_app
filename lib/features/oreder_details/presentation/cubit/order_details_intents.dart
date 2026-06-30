import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

sealed class OrderDetailsIntent {
  const OrderDetailsIntent();
}

class StartOrderDetailsIntent extends OrderDetailsIntent {
  final OrderEntity order;
  const StartOrderDetailsIntent(this.order);
}

class AdvanceOrderStepIntent extends OrderDetailsIntent {
  const AdvanceOrderStepIntent();
}

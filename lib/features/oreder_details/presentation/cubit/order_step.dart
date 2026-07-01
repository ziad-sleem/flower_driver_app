import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/localization_constants/status_constants.dart';

abstract class OrderStateValues {
  static const String accepted = 'inProgress';
  static const String picked = 'picked';
  static const String outForDelivery = 'outForDelivery';
  static const String arrived = 'arrived';
  static const String delivered = 'completed';
}

enum OrderStep {
  accepted,
  picked,
  outForDelivery,
  arrived,
  delivered;

  static OrderStep? fromState(String? state) {
    switch (state) {
      case OrderStateValues.accepted:
        return OrderStep.accepted;
      case OrderStateValues.picked:
        return OrderStep.picked;
      case OrderStateValues.outForDelivery:
        return OrderStep.outForDelivery;
      case OrderStateValues.arrived:
        return OrderStep.arrived;
      case OrderStateValues.delivered:
        return OrderStep.delivered;
      default:
        return null;
    }
  }

  String? get nextStateValue => switch (this) {
    OrderStep.accepted => OrderStateValues.picked,
    OrderStep.picked => OrderStateValues.outForDelivery,
    OrderStep.outForDelivery => OrderStateValues.arrived,
    OrderStep.arrived => null,
    OrderStep.delivered => null,
  };

  bool get isTerminal => this == OrderStep.delivered;
  String get statusLabel => switch (this) {
    OrderStep.accepted => StatusConstants.accepted,
    OrderStep.picked => StatusConstants.picked,
    OrderStep.outForDelivery => StatusConstants.outForDelivery,
    OrderStep.arrived => StatusConstants.arrived,
    OrderStep.delivered => StatusConstants.delivered,
  };

  String get buttonLabel => switch (this) {
    OrderStep.accepted => OrdersConstants.arrivedAtPickup,
    OrderStep.picked => OrdersConstants.startDeliver,
    OrderStep.outForDelivery => OrdersConstants.arrivedToUser,
    OrderStep.arrived => OrdersConstants.waitingForCustomerConfirmation,
    OrderStep.delivered => OrdersConstants.deliveredToUser,
  };
}

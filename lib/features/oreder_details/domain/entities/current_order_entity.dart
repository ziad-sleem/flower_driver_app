import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

class CurrentOrderEntity extends Equatable {
  final String state;
  final bool driverRequestedDelivery;
  final OrderEntity order;

  const CurrentOrderEntity({
    required this.state,
    required this.driverRequestedDelivery,
    required this.order,
  });

  @override
  List<Object?> get props => [state, driverRequestedDelivery, order];
}

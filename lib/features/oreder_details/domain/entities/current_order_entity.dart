import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

class CurrentOrderEntity extends Equatable {
  final String driverId;
  final String state;
  final bool driverRequestedDelivery;
  final OrderEntity order;

  const CurrentOrderEntity({
    required this.driverId,
    required this.state,
    required this.driverRequestedDelivery,
    required this.order,
  });

  @override
  List<Object?> get props => [driverId, state, driverRequestedDelivery, order];
}

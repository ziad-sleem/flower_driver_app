import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/store_entity.dart';

class DriverOrderEntity extends Equatable {
  final String? id;
  final String? driverId;
  final OrderEntity? order;
  final StoreEntity? store;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DriverOrderEntity({
    this.id,
    this.driverId,
    this.order,
    this.store,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    driverId,
    order,
    store,
    createdAt,
    updatedAt,
  ];
}

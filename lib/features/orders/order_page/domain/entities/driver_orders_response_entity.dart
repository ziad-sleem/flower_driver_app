import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/pagination_entity.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_order_entity.dart';

class DriverOrdersResponseEntity extends Equatable {
  final String? message;
  final PaginationOrderEntity? metadata;
  final List<DriverOrderEntity>? orders;

  const DriverOrdersResponseEntity({this.message, this.metadata, this.orders});

  @override
  List<Object?> get props => [message, metadata, orders];
}

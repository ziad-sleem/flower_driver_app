import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/pagination_entity.dart';

enum PaymentType { cash, visa, wallet }

enum OrderState { pending, inProgress, canceled, completed }

class OrdersResponseEntity extends Equatable {
  final String? message;
  final PaginationOrderEntity? metadata;
  final List<OrderEntity>? orders;

  const OrdersResponseEntity({this.message, this.metadata, this.orders});

  @override
  List<Object?> get props => [message, metadata, orders];
}

import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/shipping_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/store_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final Object? user;
  final List<OrderItemEntity>? orderItems;
  final double? totalPrice;
  final PaymentType? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final OrderState? state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? orderNumber;
  final int? v;
  final StoreEntity? store;
  final ShippingAddressEntity? shippingAddress;
  final DateTime? paidAt;

  const OrderEntity({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
    this.shippingAddress,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    createdAt,
    updatedAt,
    orderNumber,
    v,
    store,
    shippingAddress,
    paidAt,
  ];
}

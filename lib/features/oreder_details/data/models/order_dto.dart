import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/data/models/enums/order_details_enums.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_item_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/shipping_address_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/store_dto.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart'
    as entity;
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart'
    as entity;

part 'order_dto.g.dart';

@JsonSerializable()
class OrderDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "user")
  dynamic user;
  @JsonKey(name: "orderItems")
  List<OrderItemDto>? orderItems;
  @JsonKey(name: "totalPrice")
  double? totalPrice;
  @JsonKey(name: "paymentType")
  PaymentType? paymentType;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "isDelivered")
  bool? isDelivered;
  @JsonKey(name: "state")
  OrderState? state;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "orderNumber")
  String? orderNumber;
  @JsonKey(name: "__v")
  int? v;
  @JsonKey(name: "store")
  StoreDto? store;
  @JsonKey(name: "shippingAddress")
  ShippingAddressDto? shippingAddress;
  @JsonKey(name: "paidAt")
  DateTime? paidAt;

  OrderDto({
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

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);

  entity.OrderEntity toEntity() => entity.OrderEntity(
    id: id,
    user: user,
    orderItems: orderItems?.map((item) => item.toEntity()).toList(),
    totalPrice: totalPrice,
    paymentType: _mapPaymentType(paymentType),
    isPaid: isPaid,
    isDelivered: isDelivered,
    state: _mapOrderState(state),
    createdAt: createdAt,
    updatedAt: updatedAt,
    orderNumber: orderNumber,
    v: v,
    store: store?.toEntity(),
    shippingAddress: shippingAddress?.toEntity(),
    paidAt: paidAt,
  );

  entity.PaymentType? _mapPaymentType(PaymentType? type) {
    switch (type) {
      case PaymentType.cash:
        return entity.PaymentType.cash;
      case PaymentType.visa:
        return entity.PaymentType.visa;
      case PaymentType.wallet:
        return entity.PaymentType.wallet;
      case null:
        return null;
    }
  }

  entity.OrderState? _mapOrderState(OrderState? state) {
    switch (state) {
      case OrderState.pending:
        return entity.OrderState.pending;
      case OrderState.inProgress:
        return entity.OrderState.inProgress;
      case OrderState.canceled:
        return entity.OrderState.canceled;
      case OrderState.completed:
        return entity.OrderState.completed;
      case null:
        return null;
    }
  }
}

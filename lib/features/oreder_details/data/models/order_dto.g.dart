// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
  id: json['_id'] as String?,
  user: json['user'],
  orderItems: (json['orderItems'] as List<dynamic>?)
      ?.map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPrice: (json['totalPrice'] as num?)?.toDouble(),
  paymentType: $enumDecodeNullable(_$PaymentTypeEnumMap, json['paymentType']),
  isPaid: json['isPaid'] as bool?,
  isDelivered: json['isDelivered'] as bool?,
  state: $enumDecodeNullable(_$OrderStateEnumMap, json['state']),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  orderNumber: json['orderNumber'] as String?,
  v: (json['__v'] as num?)?.toInt(),
  store: json['store'] == null
      ? null
      : StoreDto.fromJson(json['store'] as Map<String, dynamic>),
  shippingAddress: json['shippingAddress'] == null
      ? null
      : ShippingAddressDto.fromJson(
          json['shippingAddress'] as Map<String, dynamic>,
        ),
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
);

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
  '_id': instance.id,
  'user': instance.user,
  'orderItems': instance.orderItems,
  'totalPrice': instance.totalPrice,
  'paymentType': _$PaymentTypeEnumMap[instance.paymentType],
  'isPaid': instance.isPaid,
  'isDelivered': instance.isDelivered,
  'state': _$OrderStateEnumMap[instance.state],
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'orderNumber': instance.orderNumber,
  '__v': instance.v,
  'store': instance.store,
  'shippingAddress': instance.shippingAddress,
  'paidAt': instance.paidAt?.toIso8601String(),
};

const _$PaymentTypeEnumMap = {
  PaymentType.cash: 'cash',
  PaymentType.visa: 'visa',
  PaymentType.wallet: 'wallet',
};

const _$OrderStateEnumMap = {
  OrderState.pending: 'pending',
  OrderState.accepted: 'accepted',
  OrderState.delivered: 'delivered',
  OrderState.cancelled: 'cancelled',
};

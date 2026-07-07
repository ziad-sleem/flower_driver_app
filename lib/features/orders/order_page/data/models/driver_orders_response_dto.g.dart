// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_orders_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverOrdersResponseDto _$DriverOrdersResponseDtoFromJson(
  Map<String, dynamic> json,
) => DriverOrdersResponseDto(
  message: json['message'] as String?,
  metadata: json['metadata'] == null
      ? null
      : PaginationDto.fromJson(json['metadata'] as Map<String, dynamic>),
  orders: (json['orders'] as List<dynamic>?)
      ?.map((e) => DriverOrderDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DriverOrdersResponseDtoToJson(
  DriverOrdersResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'metadata': instance.metadata,
  'orders': instance.orders,
};

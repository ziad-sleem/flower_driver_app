// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersResponseDto _$OrdersResponseDtoFromJson(Map<String, dynamic> json) =>
    OrdersResponseDto(
      message: json['message'] as String?,
      metadata: json['metadata'] == null
          ? null
          : PaginationDto.fromJson(json['metadata'] as Map<String, dynamic>),
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersResponseDtoToJson(OrdersResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'metadata': instance.metadata,
      'orders': instance.orders,
    };

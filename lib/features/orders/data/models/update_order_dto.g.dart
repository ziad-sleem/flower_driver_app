// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrderDto _$UpdateOrderDtoFromJson(Map<String, dynamic> json) =>
    UpdateOrderDto(
      id: json['_id'] as String?,
      state: json['state'] as String?,
      orderNumber: json['orderNumber'] as String?,
    );

Map<String, dynamic> _$UpdateOrderDtoToJson(UpdateOrderDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'state': instance.state,
      'orderNumber': instance.orderNumber,
    };

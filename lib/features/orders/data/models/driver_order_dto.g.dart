// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverOrderDto _$DriverOrderDtoFromJson(Map<String, dynamic> json) =>
    DriverOrderDto(
      id: json['_id'] as String?,
      driverId: json['driver'] as String?,
      order: json['order'] == null
          ? null
          : OrderDto.fromJson(json['order'] as Map<String, dynamic>),
      store: json['store'] == null
          ? null
          : StoreDto.fromJson(json['store'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DriverOrderDtoToJson(DriverOrderDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'driver': instance.driverId,
      'order': instance.order,
      'store': instance.store,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

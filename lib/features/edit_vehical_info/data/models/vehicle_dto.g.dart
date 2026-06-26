// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDto _$VehicleDtoFromJson(Map<String, dynamic> json) => VehicleDto(
  id: json['_id'] as String?,
  type: json['type'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$VehicleDtoToJson(VehicleDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'image': instance.image,
    };

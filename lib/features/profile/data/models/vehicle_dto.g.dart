// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileVehicleDto _$ProfileVehicleDtoFromJson(Map<String, dynamic> json) =>
    ProfileVehicleDto(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileVehicleDtoToJson(ProfileVehicleDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'image': instance.image,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.v,
    };

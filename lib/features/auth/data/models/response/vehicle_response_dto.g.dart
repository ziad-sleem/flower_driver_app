// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleResponseDto _$VehicleResponseDtoFromJson(Map<String, dynamic> json) =>
    VehicleResponseDto(
      message: json['message'] as String?,
      metadata: json['metadata'] == null
          ? null
          : VehicleMetaDataDto.fromJson(
              json['metadata'] as Map<String, dynamic>,
            ),
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((e) => VehicleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VehicleResponseDtoToJson(VehicleResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'metadata': instance.metadata,
      'vehicles': instance.vehicles,
    };

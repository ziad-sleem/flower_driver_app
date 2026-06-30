// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_vehicle_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleVehicleResponseDto _$SingleVehicleResponseDtoFromJson(
  Map<String, dynamic> json,
) => SingleVehicleResponseDto(
  message: json['message'] as String?,
  vehicle: json['vehicle'] == null
      ? null
      : ProfileVehicleDto.fromJson(json['vehicle'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SingleVehicleResponseDtoToJson(
  SingleVehicleResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'vehicle': instance.vehicle,
};

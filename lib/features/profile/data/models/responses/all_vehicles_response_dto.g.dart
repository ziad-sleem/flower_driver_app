// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_vehicles_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllVehiclesResponseDto _$AllVehiclesResponseDtoFromJson(
  Map<String, dynamic> json,
) => AllVehiclesResponseDto(
  message: json['message'] as String?,
  vehicles: (json['vehicles'] as List<dynamic>?)
      ?.map((e) => ProfileVehicleDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AllVehiclesResponseDtoToJson(
  AllVehiclesResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'vehicles': instance.vehicles,
};

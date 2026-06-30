// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverProfileResponseDto _$DriverProfileResponseDtoFromJson(
  Map<String, dynamic> json,
) => DriverProfileResponseDto(
  message: json['message'] as String?,
  driver: json['driver'] == null
      ? null
      : DriverDto.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DriverProfileResponseDtoToJson(
  DriverProfileResponseDto instance,
) => <String, dynamic>{'message': instance.message, 'driver': instance.driver};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply_now_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplyNowResponseDto _$ApplyNowResponseDtoFromJson(Map<String, dynamic> json) =>
    ApplyNowResponseDto(
      message: json['message'] as String?,
      driver: json['driver'] == null
          ? null
          : DriverDto.fromJson(json['driver'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$ApplyNowResponseDtoToJson(
  ApplyNowResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'driver': instance.driver,
  'token': instance.token,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDataResponseDto _$ProfileDataResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProfileDataResponseDto(
  message: json['message'] as String?,
  driver: json['driver'] == null
      ? null
      : ProfileDriverDto.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileDataResponseDtoToJson(
  ProfileDataResponseDto instance,
) => <String, dynamic>{'message': instance.message, 'driver': instance.driver};

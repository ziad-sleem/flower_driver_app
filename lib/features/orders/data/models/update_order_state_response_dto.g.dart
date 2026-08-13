// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_order_state_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrderStateResponseDto _$UpdateOrderStateResponseDtoFromJson(
  Map<String, dynamic> json,
) => UpdateOrderStateResponseDto(
  message: json['message'] as String?,
  order: json['orders'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UpdateOrderStateResponseDtoToJson(
  UpdateOrderStateResponseDto instance,
) => <String, dynamic>{'message': instance.message, 'orders': instance.order};

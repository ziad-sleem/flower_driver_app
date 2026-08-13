import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/orders/domain/entities/update_order_state_response_entity.dart'
    as entity;

part 'update_order_state_response_dto.g.dart';

@JsonSerializable()
class UpdateOrderStateResponseDto {
  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "orders")
  final Map<String, dynamic>? order;

  const UpdateOrderStateResponseDto({this.message, this.order});

  factory UpdateOrderStateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStateResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderStateResponseDtoToJson(this);

  entity.UpdateOrderStateResponseEntity toEntity() {
    return entity.UpdateOrderStateResponseEntity(message: message);
  }
}

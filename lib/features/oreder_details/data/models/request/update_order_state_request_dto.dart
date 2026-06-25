import 'package:json_annotation/json_annotation.dart';

part 'update_order_state_request_dto.g.dart';

@JsonSerializable()
class UpdateOrderStateRequestDto {
  @JsonKey(name: "state")
  final String state;

  const UpdateOrderStateRequestDto({required this.state});

  factory UpdateOrderStateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderStateRequestDtoToJson(this);
}

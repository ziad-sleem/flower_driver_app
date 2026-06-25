import 'package:json_annotation/json_annotation.dart';
part 'update_order_dto.g.dart';

@JsonSerializable()
class UpdateOrderDto {
  @JsonKey(name: "_id")
  String? id;

  @JsonKey(name: "state")
  String? state;

  @JsonKey(name: "orderNumber")
  String? orderNumber;

  UpdateOrderDto({this.id, this.state, this.orderNumber});

  factory UpdateOrderDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderDtoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/update_vehicle_response_entity.dart';

part 'update_vehicle_response_dto.g.dart';

@JsonSerializable()
class UpdateVehicleResponseDto {
  @JsonKey(name: 'message')
  final String? message;

  UpdateVehicleResponseDto({this.message});

  factory UpdateVehicleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateVehicleResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateVehicleResponseDtoToJson(this);

  UpdateVehicleResponseEntity toEntity() {
    return UpdateVehicleResponseEntity(message: message);
  }
}

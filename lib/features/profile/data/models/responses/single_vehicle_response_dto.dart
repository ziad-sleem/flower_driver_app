import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/data/models/vehicle_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/single_vehicle_response_entity.dart';

part 'single_vehicle_response_dto.g.dart';

@JsonSerializable()
class SingleVehicleResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "vehicle")
  final VehicleDto? vehicle;

  SingleVehicleResponseDto({this.message, this.vehicle});

  factory SingleVehicleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SingleVehicleResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SingleVehicleResponseDtoToJson(this);

  SingleVehicleResponseEntity toEntity() {
    return SingleVehicleResponseEntity(
      message: message,
      vehicle: vehicle?.toEntity(),
    );
  }
}

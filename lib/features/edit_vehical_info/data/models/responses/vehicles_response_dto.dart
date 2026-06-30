import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/edit_vehical_info/data/models/vehicle_dto.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/vehicles_response_entity.dart';

part 'vehicles_response_dto.g.dart';

@JsonSerializable()
class VehiclesResponseDto {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'vehicles')
  final List<VehicleDto>? vehicles;

  VehiclesResponseDto({this.message, this.vehicles});

  factory VehiclesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehiclesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclesResponseDtoToJson(this);

  VehiclesResponseEntity toEntity() {
    return VehiclesResponseEntity(
      message: message,
      vehicles: vehicles?.map((e) => e.toEntity()).toList(),
    );
  }
}

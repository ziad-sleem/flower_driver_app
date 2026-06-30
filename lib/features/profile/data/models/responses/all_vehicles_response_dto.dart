import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/data/models/vehicle_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';

part 'all_vehicles_response_dto.g.dart';

@JsonSerializable()
class AllVehiclesResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "vehicles")
  final List<ProfileVehicleDto>? vehicles;

  AllVehiclesResponseDto({this.message, this.vehicles});

  factory AllVehiclesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AllVehiclesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AllVehiclesResponseDtoToJson(this);

  AllVehiclesResponseEntity toEntity() {
    return AllVehiclesResponseEntity(
      message: message,
      vehicles: vehicles?.map((e) => e.toEntity()).toList(),
    );
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_meta_data_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';
part 'vehicle_response_dto.g.dart';

@JsonSerializable()
class VehicleResponseDto {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  VehicleMetaDataDto? metadata;
  @JsonKey(name: "vehicles")
  List<VehicleDto>? vehicles;

  VehicleResponseDto({this.message, this.metadata, this.vehicles});

  factory VehicleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleResponseDtoToJson(this);

  VehicleResponseEntity toEntity() {
    return VehicleResponseEntity(
      vehicles: vehicles?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

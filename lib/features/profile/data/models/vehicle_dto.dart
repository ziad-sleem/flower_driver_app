import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';

part 'vehicle_dto.g.dart';

@JsonSerializable()
class VehicleDto {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "image")
  final String? image;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "__v")
  final int? v;

  VehicleDto({
    this.id,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDtoToJson(this);

  VehicleEntity toEntity() {
    return VehicleEntity(id: id, type: type, image: image);
  }
}

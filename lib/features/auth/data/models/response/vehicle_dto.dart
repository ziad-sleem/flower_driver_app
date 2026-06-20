import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_entity%20.dart';
part 'vehicle_dto.g.dart';

@JsonSerializable()
class VehicleDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "__v")
  int? v;

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
  return VehicleEntity(
    id: id ?? "",
    type: type ?? "",
    image: image ?? "",
  );
}
}

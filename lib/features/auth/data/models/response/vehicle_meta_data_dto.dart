import 'package:json_annotation/json_annotation.dart';
part 'vehicle_meta_data_dto.g.dart';

@JsonSerializable()
class VehicleMetaDataDto {
  @JsonKey(name: "currentPage")
  int? currentPage;
  @JsonKey(name: "totalPages")
  int? totalPages;
  @JsonKey(name: "limit")
  int? limit;
  @JsonKey(name: "totalItems")
  int? totalItems;

  VehicleMetaDataDto({
    this.currentPage,
    this.totalPages,
    this.limit,
    this.totalItems,
  });

  factory VehicleMetaDataDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleMetaDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleMetaDataDtoToJson(this);
}

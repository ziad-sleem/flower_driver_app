import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/store_entity.dart'
    as entity;

part 'store_dto.g.dart';

@JsonSerializable()
class StoreDto {
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'latLong')
  final String? latLong;

  @JsonKey(name: 'lat')
  final dynamic lat;

  @JsonKey(name: 'long')
  final dynamic long;

  @JsonKey(name: 'lng')
  final dynamic lng;

  const StoreDto({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
    this.lat,
    this.long,
    this.lng,
  });

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDtoToJson(this);

  entity.StoreEntity toEntity() {
    String? latStr;
    String? longStr;

    if (latLong != null && latLong!.isNotEmpty) {
      final parts = latLong!.split(',');
      if (parts.length == 2) {
        latStr = parts[0].trim();
        longStr = parts[1].trim();
      }
    }

    if (latStr == null || longStr == null) {
      final l = lat ?? latStr;
      final ln = long ?? lng ?? longStr;
      if (l != null) latStr = l.toString();
      if (ln != null) longStr = ln.toString();
    }

    return entity.StoreEntity(
      name: name,
      image: image,
      address: address,
      phoneNumber: phoneNumber,
      lat: latStr,
      long: longStr,
    );
  }
}

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

  const StoreDto({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDtoToJson(this);

  entity.StoreEntity toEntity() => entity.StoreEntity(
    name: name,
    image: image,
    address: address,
    phoneNumber: phoneNumber,
    latLong: latLong,
  );
}

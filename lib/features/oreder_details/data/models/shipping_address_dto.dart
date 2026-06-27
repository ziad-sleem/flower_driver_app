import 'package:json_annotation/json_annotation.dart';

import 'package:tracking_app/features/oreder_details/domain/entities/shipping_entity.dart'
    as entity;

part 'shipping_address_dto.g.dart';

@JsonSerializable()
class ShippingAddressDto {
  @JsonKey(name: "street")
  String? street;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "lat")
  String? lat;
  @JsonKey(name: "long")
  String? long;

  ShippingAddressDto({this.street, this.city, this.phone, this.lat, this.long});

  factory ShippingAddressDto.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressDtoToJson(this);

  entity.ShippingAddressEntity toEntity() => entity.ShippingAddressEntity(
    street: street,
    city: city,
    phone: phone,
    lat: lat,
    long: long,
  );
}

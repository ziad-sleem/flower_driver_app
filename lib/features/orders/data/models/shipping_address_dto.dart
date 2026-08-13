import 'package:json_annotation/json_annotation.dart';

import 'package:tracking_app/features/orders/domain/entities/shipping_entity.dart'
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
  dynamic lat;
  @JsonKey(name: "long")
  dynamic long;
  @JsonKey(name: "lng")
  dynamic lng;

  ShippingAddressDto({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
    this.lng,
  });

  factory ShippingAddressDto.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressDtoToJson(this);

  entity.ShippingAddressEntity toEntity() => entity.ShippingAddressEntity(
    street: street,
    city: city,
    phone: phone,
    lat: lat?.toString(),
    long: (long ?? lng)?.toString(),
  );
}

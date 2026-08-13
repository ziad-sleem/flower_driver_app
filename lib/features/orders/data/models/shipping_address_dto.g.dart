// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddressDto _$ShippingAddressDtoFromJson(Map<String, dynamic> json) =>
    ShippingAddressDto(
      street: json['street'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      lat: json['lat'],
      long: json['long'],
      lng: json['lng'],
    );

Map<String, dynamic> _$ShippingAddressDtoToJson(ShippingAddressDto instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'phone': instance.phone,
      'lat': instance.lat,
      'long': instance.long,
      'lng': instance.lng,
    };
